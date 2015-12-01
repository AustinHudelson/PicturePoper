//
//  PieceGrid.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/29/15.
//  Copyright © 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit
class PieceGrid {
    var pieces: [[Piece]] = [[]]
    
    init (scene: PicturePoperGameScene) {
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
        let waitForSwapAnimationAction = SKAction.waitForDuration(Piece.swapActionDuration)
        let handleSwapAction = SKAction.group([executeSwapBlockAction, waitForSwapAnimationAction])
        
        //After swap check for matches?
        
        return handleSwapAction
    }
    
    func removePiece(p: Piece) {
        //Removes a piece from the grid and fills in the hole left by that grid piece.
    }
    
    func setPieceImage(ID: String, image: UIImage){
        for p in pieces {
            for q in p {
                if q.ID == ID {
                    q.texture = SKTexture(image: image)
                }
            }
        }
    }
}