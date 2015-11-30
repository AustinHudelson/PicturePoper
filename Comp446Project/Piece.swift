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
    
    private var GScene: PicturePoperGameScene
    private let maxGridX: Int
    private let maxGridY: Int
    private var ID: String
    private var pieceGrid: PieceGrid
    
    static let swapActionDuration = NSTimeInterval(0.5)
    
    init(texture: SKTexture?, gameScene: PicturePoperGameScene, initialGridPosition: PieceGridPosition, grid: PieceGrid) {
        GScene = gameScene
        pieceGrid = grid
        gridPosition = initialGridPosition
        maxGridX = gameScene.piecesX
        maxGridY = gameScene.piecesY
        //Hopefully unique ID for each description of the texture.
        //ID will be used to check for matches
        if texture != nil {
            ID = texture!.description
        } else {
            ID = ""
        }
        print(ID)
        let dimention = max(min((CGRectGetMaxX(gameScene.frame)-(gameScene.borderX))/CGFloat(maxGridX), (CGRectGetMaxY(gameScene.frame)-(gameScene.borderY))/CGFloat(maxGridY)), 5)
        //Give the sprite a random color for now.
        let randomColor: UIColor = ([UIColor.blackColor(), UIColor.blueColor(), UIColor.whiteColor()])[Int.random(0...2)]
        super.init(texture: texture, color: randomColor, size: CGSize(width: dimention, height: dimention))
        
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
    
    //All return actions to handle the swipe. Does not handle it.
    func swipeUp() -> SKAction? {
        print("up")
        if let otherPiece = getAbovePiece() {
            return pieceGrid.swapPieces(self, p2:otherPiece)
        } else {
            //Error move
            return nil
        }
    }
    
    func swipeDown() -> SKAction? {
        print("down")
        if let otherPiece = getBelowPiece() {
            return pieceGrid.swapPieces(self, p2:otherPiece)
        } else {
            //Error move
            return nil
        }
    }
    
    func swipeLeft() -> SKAction? {
        print("Left")
        if let otherPiece = getLeftPiece() {
            return pieceGrid.swapPieces(self, p2:otherPiece)
        } else {
            //Error move
            return nil
        }
    }
    
    func swipeRight() -> SKAction? {
        print("Right")
        if let otherPiece = getRightPiece() {
            return pieceGrid.swapPieces(self, p2:otherPiece)
        } else {
            //Error move
            return nil
        }
    }
    
    func destroy() {
        //Animate a destruction
        destroyed = true
    }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}