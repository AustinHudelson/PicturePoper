//
//  PicturePoperGameScene.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/28/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class PicturePoperGameScene: SKScene {
    
    
    let piecesX = PieceGridPosition.maxX+1
    let piecesY = PieceGridPosition.maxY+1
    let bottomMargin: CGFloat = 8.0
    let topMargin: CGFloat = 64.0
    let leftMargin: CGFloat = 8.0
    let rightMargin: CGFloat = 8.0
    let borderX: CGFloat = 16.0 //Left+Right Margin
    let borderY: CGFloat = 72.0 //Top+Bottom Margin
    
    
    var myLabel: SKLabelNode!
    var pieceGrid: PieceGrid!
    var animating: Bool = false //Toggles if animation is in progress. if yes then touch input to the pieces is blocked.
    var selectedPiece: Piece? = nil
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        pieceGrid = PieceGrid(scene: self)
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "\(CGRectGetMaxY(self.frame))  \(CGRectGetMaxX(self.frame))"
        myLabel.fontSize = 16;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {
            if selectedPiece == nil { //No piece is already being selected
                if let touchedPiece = self.nodeAtPoint(touch.locationInNode(self)) as? Piece { //Touched node is a piece
                    selectedPiece = touchedPiece
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch moves */
        let minimumMovedDistance: CGFloat = 50.0
        if (selectedPiece != nil && animating == false) {
            for touch in touches {
                if minimumMovedDistance < CGPoint.getDistance(selectedPiece!.position, p2:touch.locationInNode(self)) {
                    print("A\(selectedPiece!.position), \(touch.locationInView(self.view))")
                    var swapAction: SKAction?
                    switch (touch.directionFromPoint(selectedPiece!.position, inNode: selectedPiece!.parent!)){
                        case "Up": swapAction = selectedPiece!.swipeUp()
                        case "Down": swapAction = selectedPiece!.swipeDown()
                        case "Left": swapAction = selectedPiece!.swipeLeft()
                        case "Right": swapAction = selectedPiece!.swipeRight()
                        default: continue
                    }
                    selectedPiece = nil
                    if swapAction != nil {
                        let startAnimating = SKAction.runBlock({
                            self.animating = true
                        })
                        let stopAnimating = SKAction.runBlock({
                            self.animating = false
                        })
                        let handleSwipeAction = SKAction.sequence([startAnimating, swapAction!, stopAnimating])
                        runAction(handleSwipeAction)
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch ends */
        if touches.count != 0 {
            selectedPiece = nil
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //myLabel.text = "\(CGRectGetMaxY(self.frame))  \(CGRectGetMaxX(self.frame)) \(currentTime)"
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
    }
    
    override func didChangeSize(oldSize: CGSize) {
        myLabel?.text = "\(self.size.height) \(self.size.width)"
        if pieceGrid != nil {   //Scene has to have been presented
            for p in pieceGrid.pieces {
                for q in p {
                    q.reposition()
                }
            }
        }
    }
}
