//
//  PieceGrid.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/29/15.
//  Copyright © 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
class PieceGrid {
    var pieces: [[Piece]] = []
    var iDImages: [String:UIImage] = [String:UIImage]()
    private var gameScene: PicturePoperGameScene
    
    init (scene: PicturePoperGameScene) {
        gameScene = scene
        //Add the initial Pieces
        for i in 0...PieceGridPosition.maxX {
            pieces.append([])
            for j in 0...PieceGridPosition.maxY {
                //Use spaceship as placeholder initial texture
                //Create a grid position for the piece
                //Set the piece ID to be an integer index converted to a string
                //unique piece IDs there should be
                let newPiece = Piece(initialTexture: SKTexture(imageNamed: "Spaceship"), gameScene: scene, initialGridPosition:PieceGridPosition(x:i, y:j)!, grid: self, id: String(Int.random(0...Piece.typesOfPieces-1)))
                pieces[i].append(newPiece)
                scene.addChild(newPiece)
            }
        }
        print(pieces.count)
        print(pieces[0].count)
    }
    
    func getPiece(pos: PieceGridPosition) -> Piece {
        return pieces[pos.x][pos.y]
    }
    
    func swapPieces(p1: Piece, p2: Piece) -> SKAction {
        let moveP1 = p1.moveToGridPositionOverTime(p2.gridPosition.copy())
        let moveP2 = p2.moveToGridPositionOverTime(p1.gridPosition.copy())
        let executeSwapBlockAction = SKAction.runBlock({
            //Swap positions in the array
            self.pieces[p1.gridPosition.x][p1.gridPosition.y] = p2
            self.pieces[p2.gridPosition.x][p2.gridPosition.y] = p1
            //Run the actions that will run the animation and update the gridPosition var in the Pieces
            p1.runAction(moveP1)
            p2.runAction(moveP2)
        })
        //Is it best to "fake" an action that takes a certain amount of time by pairing a block with a wait?
        //Is there a better method using RunActionWithCompletionBlock
        //Use the duration property of the returned method?
        let waitForSwapAnimationAction = SKAction.waitForDuration(NSTimeInterval(0.75))
        let handleSwapAction = SKAction.group([executeSwapBlockAction, waitForSwapAnimationAction])
        return handleSwapAction
    }
    
    func removePiece(p: Piece) {
        //Removes a piece from the grid does not fill the hole left by this piece.
        p.destroy()
    }
    
    //Fills in hole left by pieces removed.
    func fallIn() {
        var fallCount = 0
        var fallBy: [[Int]] = []
        var pieceDrops: [Int] = []
        
        //Initialize fallby and pieceDrop arrays
        for x in 0...pieces.count-1 {
            fallBy.append([])
            pieceDrops.append(0)
            for _ in 0...pieces[x].count-1 {
                fallBy[x].append(0)
            }
        }
        
        //Fillin the fallBy and pieceDrop arrays
        for x in 0...pieces.count-1 {
            fallCount = 0
            var y = pieces[x].count
            //Iterate over column backwards (from top to bottom)
            while (y > 0){
                y -= 1
                if pieces[x][y].destroyed == true {
                    fallCount += 1
                    fallBy[x][y] = 0
                } else {
                    fallBy[x][y] = fallCount
                }
            }
            pieceDrops[x] = fallCount
        }
        
        //Existing piece drop downs
        
        var moveActions: [SKAction] = []
        
        for x in 0...pieces.count-1 {
            for y in 0...pieces[x].count-1{
                //Does the piece at x y need to fall?
                if fallBy[x][y] != 0 {
                    //Create and add the movement action to themove array
                    let movingPiece = pieces[x][y]
                    let newPos = movingPiece.gridPosition.getBelowPositionBy(fallBy[x][y])
                    let moveAction = movingPiece.moveToGridPositionOverTime(newPos)
                    //This action is a BLOCK that runs the move action on the correct piece.
                    //The actions stored in moveActions are not specific to any SKNode
                    
                    moveActions.append(SKAction.runBlock({
                        movingPiece.runAction(moveAction)
                        self.pieces[newPos.x][newPos.y] = movingPiece
                    }))
                    //let moveP1 = p1.moveToGridPositionOverTime(p2.gridPosition.copy())
                }
            }
        }
        
        //New Piece Fallins
        
        var createAndFallActions: [SKAction] = []
        
        
        for x in 0...pieceDrops.count-1 {
            var dropInNumber = 0
            //Using pieces[x][0] as example.
            //A piece in the top row. Does not matter if it was just destroyed
            let examplePiece: Piece = pieces[x][0]
            let examplePieceXPosition = examplePiece.position.x
            let examplePieceYPosition = examplePiece.position.y
            while (dropInNumber < pieceDrops[x]){
                //Init a new piece and drop it in
                dropInNumber += 1
                print("Dropping in action create")
                let destinationPosition = PieceGridPosition(x: x, y: pieceDrops[x]-dropInNumber)!
                let aboveSceneX = examplePieceXPosition
                //Position above the grid initially to allow a smooth dropin
                let aboveSceneY = examplePieceYPosition + (CGFloat(pieceDrops[x]) * examplePiece.size.height)
                let newPieceFallingAction: SKAction = SKAction.runBlock({
                    print("Building a new piece")
                    print("\(destinationPosition.x)\(destinationPosition.y)")
                    let newPieceID = String(Int.random(0...Piece.typesOfPieces-1))
                    
                    var newPieceTexture = SKTexture(imageNamed: "Spaceship")
                    if let newPieceImage: UIImage = self.iDImages[newPieceID] {
                        newPieceTexture = SKTexture(image: newPieceImage)
                    }
                    
                    //Declairing the piece automatically adds it to the scene so immediately reposition
                    let newPiece = Piece(initialTexture: newPieceTexture, gameScene: self.gameScene, initialGridPosition: destinationPosition, grid: self, id: newPieceID)
                    newPiece.position = CGPoint(x: aboveSceneX, y: aboveSceneY)
                    self.gameScene.addChild(newPiece)
                    //Fall in Action
                    let fallAction = newPiece.moveToGridPositionOverTime(destinationPosition)
                    newPiece.runAction(fallAction)
                    //Overwrite the old piece in the array
                    self.pieces[destinationPosition.x][destinationPosition.y] = newPiece
                })
                createAndFallActions.append(newPieceFallingAction)
            }
        }
        
        //Run actions
        //TODO Add input block for animation time
        var finalHandleAction: [SKAction] = []
        for a in moveActions {
            finalHandleAction.append(a)
        }
        finalHandleAction.append(SKAction.waitForDuration(NSTimeInterval(0.5)))
        for b in createAndFallActions {
            finalHandleAction.append(b)
            finalHandleAction.append(SKAction.waitForDuration(NSTimeInterval(0.15)))
        }
        //Action to wait for completion of animations
        finalHandleAction.append(SKAction.runBlock({
            self.clearAllMatches()
        }))
        self.gameScene.runAction(SKAction.sequence(finalHandleAction))
    }
    
    //Bruteforce way of cheching for all matches on the board. could optimize by only checking truly
    //Disturbed pieces.
    func clearAllMatches(){
        //Create a set of all pieces
        var allPieces: Set<Piece> = []
        for q in pieces {
            for p in q {
                allPieces.insert(p)
            }
        }
        let matches = Piece.getMatchSet(disturbedPieces: allPieces)
        //Check for and handle matches once the swap completes.
        for p in matches {
            removePiece(p)
        }
        
        //Cancle if there are no matches
        if matches.count == 0 {
            return
        }
        
        //Fill in the holes left in the board after a delay for the destruction animation
        let delay = SKAction.waitForDuration(NSTimeInterval(1.25))
        let fallInBlock = SKAction.runBlock({
            self.fallIn()
        })
        
        self.gameScene.runAction(SKAction.sequence([delay, fallInBlock]))
    }
    
    func randomSwaps() {
        let swapCount = 7
        var swaps: [SKAction] = []
        var swapedPieces: Set<Piece> = []
        var p1: Piece?
        var p2: Piece?
        for _ in 0...swapCount-1 {
            //Randomly pick pieces till you find 2 that are not being swaped yet
            while true {
                p1 = getRandomPiece()
                if swapedPieces.contains(p1!) {
                    continue
                } else {
                    swapedPieces.insert(p1!)
                    break
                }
            }
            while true {
                p2 = getRandomPiece()
                if swapedPieces.contains(p2!) {
                    continue
                } else {
                    swapedPieces.insert(p2!)
                    break
                }
            }
            swaps.append(swapPieces(p1!, p2: p2!))
        }
        gameScene.runAction(SKAction.group(swaps))
    }
    
    func getRandomPiece() -> Piece {
        let r1 = Int.random(0...pieces.count-1)
        let r2 = Int.random(0...pieces[0].count-1)
        return pieces[r1][r2]
    }
    
    func setPieceImage(ID: String, image: UIImage){
        iDImages[ID] = image
        for p in pieces {
            for q in p {
                if q.ID == ID {
                    q.texture = SKTexture(image: image)
                }
            }
        }
    }
}