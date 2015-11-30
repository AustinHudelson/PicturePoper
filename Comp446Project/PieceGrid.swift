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
                let newPiece = Piece(texture: SKTexture(imageNamed: "Spaceship"), gameScene: scene, initialGridPosition:PieceGridPosition(x:i, y:j)!, grid: self)
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
        let waitForSwapAnimationAction = SKAction.waitForDuration(Piece.swapActionDuration)
        let handleSwapAction = SKAction.group([executeSwapBlockAction, waitForSwapAnimationAction])
        return handleSwapAction
    }
}