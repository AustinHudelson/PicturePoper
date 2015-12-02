//
//  Piece.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/28/15.
//  Copyright © 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class Piece: SKSpriteNode {
    
    var destroyed: Bool = false
    var gridPosition: PieceGridPosition
    var ID: String
    
    private var GScene: PicturePoperGameScene
    private let maxGridX: Int
    private let maxGridY: Int
    private var pieceGrid: PieceGrid
    
    static let swapActionDuration = NSTimeInterval(0.5)
    static let destroyActionDuration = NSTimeInterval(0.5)
    static let matchRequirement = 3
    static let typesOfPieces = 5
    
    init(initialTexture: SKTexture?, gameScene: PicturePoperGameScene, initialGridPosition: PieceGridPosition, grid: PieceGrid, id: String) {
        GScene = gameScene
        pieceGrid = grid
        gridPosition = initialGridPosition
        maxGridX = gameScene.piecesX
        maxGridY = gameScene.piecesY
        //Hopefully unique ID for each description of the texture.
        //ID will be used to check for matches
        ID = id
        let dimention = max(min((CGRectGetMaxX(gameScene.frame)-(gameScene.borderX))/CGFloat(maxGridX), (CGRectGetMaxY(gameScene.frame)-(gameScene.borderY))/CGFloat(maxGridY)), 5)
        //Give the sprite a random color for now.
        let randomColor: UIColor = ([UIColor.blackColor(), UIColor.blueColor(), UIColor.whiteColor()])[Int.random(0...2)]
        super.init(texture: initialTexture, color: randomColor, size: CGSize(width: dimention, height: dimention))
        
        moveToGridPositionInstantly(gridPosition)
    }
    
    //Returns an action that will cause the sequence to run
    
    private func getAbovePiece() -> Piece? {
        if let newGridPosition = gridPosition.getAbovePosition() {
            return pieceGrid.getPiece(newGridPosition)
        }
        return nil
    }
    private func getBelowPiece() -> Piece? {
        if let newGridPosition = gridPosition.getBelowPosition() {
            return pieceGrid.getPiece(newGridPosition)
        }
        return nil
    }
    private func getLeftPiece() -> Piece? {
        if let newGridPosition = gridPosition.getLeftPosition() {
            return pieceGrid.getPiece(newGridPosition)
        }
        return nil
    }
    private func getRightPiece() -> Piece? {
        if let newGridPosition = gridPosition.getRightPosition() {
            return pieceGrid.getPiece(newGridPosition)
        }
        return nil
    }
    
    //MARK: Swipe actions
    
    //All return actions to handle the swipe. Actually handels the swipe
    private func swipeWith(other: Piece?) ->SKAction? {
        //TODO Add input blocking for Animation Time
        if other != nil {
            let otherPiece = other!
            let swipeAction = pieceGrid.swapPieces(self, p2:otherPiece)
            runAction(swipeAction, completion: {
                //Check for and handle matches once the swap completes.
                let disturbedPieces: Set<Piece> = [self, otherPiece]
                let matchedPieces: Set<Piece> = Piece.getMatchSet(disturbedPieces: disturbedPieces)
                //Animated?
                for p in matchedPieces {
                    self.pieceGrid.removePiece(p)
                }
                self.pieceGrid.fallIn()
            })
            return swipeAction
        } else {
            //Error move
            return nil
        }
    }
    
    func swipeUp() -> SKAction? {return swipeWith(getAbovePiece())}
    func swipeDown() -> SKAction? {return swipeWith(getBelowPiece())}
    func swipeLeft() -> SKAction? {return swipeWith(getLeftPiece())}
    func swipeRight() -> SKAction? {return swipeWith(getRightPiece())}
    
    func destroy() {
        //Animate a destruction
        destroyed = true
    }
    
    //MARK Repositioning pieces
    
    //Immediately resizes and places the piece at its current XY grid position in the scene
    func reposition() {
        let dimention = min((CGRectGetMaxX(GScene.frame)-(GScene.borderX))/CGFloat(maxGridX), (CGRectGetMaxY(GScene.frame)-(GScene.borderY))/CGFloat(maxGridY))
        self.size = CGSize(width: dimention, height: dimention)
        moveToGridPositionInstantly(gridPosition)
    }
    
    private func moveToGridPositionInstantly(newPosition: PieceGridPosition){
        gridPosition.x = newPosition.x
        gridPosition.y = newPosition.y
        let newX = (CGFloat(gridPosition.x) * self.size.width)+(self.size.width/2.0)+GScene.leftMargin
        let newY = CGRectGetMaxY(GScene.frame)-((CGFloat(gridPosition.y) * self.size.height)+(self.size.height/2.0)+GScene.topMargin)
        self.position = CGPoint(x:newX, y:newY)
    }
    
    //Returns the SKAction of the move animation. Does not execute it'
    //Running the action alone on the Piece will not update its position in the PieceGrid either
    func moveToGridPositionOverTime(newPosition: PieceGridPosition) -> SKAction {
        let changeGridPositionAction = SKAction.runBlock({
            print("Moving to: \(newPosition.x), \(newPosition.y)")
            self.gridPosition.x = newPosition.x
            self.gridPosition.y = newPosition.y
        })
        let newX = (CGFloat(newPosition.x) * self.size.width)+(self.size.width/2.0)+GScene.leftMargin
        let newY = CGRectGetMaxY(GScene.frame)-((CGFloat(newPosition.y) * self.size.height)+(self.size.height/2.0)+GScene.topMargin)
        let moveOverTimeAction: SKAction = SKAction.moveTo(CGPoint(x:newX, y:newY), duration: Piece.swapActionDuration)
        let moveToGridPositionOverTimeAction = SKAction.sequence([changeGridPositionAction, moveOverTimeAction])
        return moveToGridPositionOverTimeAction
    }
    
    //Returns the SKAction that will destroy this piece when ran on the piece.
    //Does not execute it.
    func destroyPiece(newPosition: PieceGridPosition) -> SKAction {
        let beginDestroy = SKAction.runBlock({
            self.destroyed = true
        })
        let destroyAnimation: SKAction = SKAction.waitForDuration(Piece.destroyActionDuration)
        let finalizeDestroy = SKAction.runBlock({
            self.removeFromParent()
            
        })
        let destroy = SKAction.sequence([beginDestroy, destroyAnimation, finalizeDestroy])
        return destroy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isAMatch(otherPiece: Piece) -> Bool {
        if self.ID == otherPiece.ID {
            return true
        }
        return false
    }
    
    func checkForVerticalMatches() -> Set<Piece> {
        let topMatch = self.getTopMatch()
        let bottomMatch = self.getBottomMatch()
        let vertMatch = Piece.getPiecesBetween(topMatch, p2: bottomMatch)
        //Must have atleast "3"? in a column with same ID to be considered a match
        if vertMatch.count >= Piece.matchRequirement {
            return vertMatch
        }
        return []
    }
    
    func checkForHorisontalMatches() -> Set<Piece> {
        let topMatch = self.getLeftMatch()
        let bottomMatch = self.getRightMatch()
        let vertMatch = Piece.getPiecesBetween(topMatch, p2: bottomMatch)
        //Must have atleast "3"? in a column with same ID to be considered a match
        if vertMatch.count >= Piece.matchRequirement {
            return vertMatch
        }
        return []
    }
    
    static func getMatchSet(disturbedPieces pieces: Set<Piece>) -> Set<Piece> {
        var returnSet: Set<Piece> = []
        for p in pieces {
            returnSet = returnSet.union(p.checkForVerticalMatches())
            returnSet = returnSet.union(p.checkForHorisontalMatches())
        }
        return returnSet
    }
    
    private static func getPiecesBetween(p1: Piece, p2: Piece) -> Set<Piece> {
        //Returns an empty set if the pieces are not in the same row or column.
        var returnset: Set<Piece> = []
        let xloc1 = p1.gridPosition.x
        let xloc2 = p2.gridPosition.x
        let yloc1 = p1.gridPosition.y
        let yloc2 = p2.gridPosition.y
        if (xloc1 == xloc2) {
            for y in min(yloc1, yloc2) ... max(yloc1, yloc2) {
                returnset.insert(p1.pieceGrid.getPiece(PieceGridPosition(x: xloc1, y: y)!))
            }
        }
        if (yloc1 == yloc2) {
            for x in min(xloc1, xloc2) ... max(xloc1, xloc2) {
                returnset.insert(p1.pieceGrid.getPiece(PieceGridPosition(x: x, y: yloc1)!))
            }
        }
        return returnset
    }
    
    private func getTopMatch() -> Piece {
        var nextPiece: Piece = self
        repeat {
            if let temp = nextPiece.getAbovePiece() {
                if (temp.ID == self.ID) {
                    nextPiece = temp
                    continue
                }
            }
            break
        } while (true)
        return nextPiece
    }
    
    private func getBottomMatch() -> Piece {
        var nextPiece: Piece = self
        repeat {
            if let temp = nextPiece.getBelowPiece() {
                if (temp.ID == self.ID) {
                    nextPiece = temp
                    continue
                }
            }
            break
        } while (true)
        return nextPiece
    }
    
    private func getLeftMatch() -> Piece {
        var nextPiece: Piece = self
        repeat {
            if let temp = nextPiece.getLeftPiece() {
                if (temp.ID == self.ID) {
                    nextPiece = temp
                    continue
                }
            }
            break
        } while (true)
        return nextPiece
    }
    
    private func getRightMatch() -> Piece {
        var nextPiece: Piece = self
        repeat {
            if let temp = nextPiece.getRightPiece() {
                if (temp.ID == self.ID) {
                    nextPiece = temp
                    continue
                }
            }
            break
        } while (true)
        return nextPiece
    }
}