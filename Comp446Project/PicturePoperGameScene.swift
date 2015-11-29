//
//  PicturePoperGameScene.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/28/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class PicturePoperGameScene: SKScene {
    let piecesX = 8
    let piecesY = 8
    let bottomMargin: CGFloat = 8.0
    let topMargin: CGFloat = 64.0
    let leftMargin: CGFloat = 8.0
    let rightMargin: CGFloat = 8.0
    let borderX: CGFloat = 16.0 //Left+Right Margin
    let borderY: CGFloat = 72.0 //Top+Bottom Margin
    var myLabel: SKLabelNode!
    var pieces: [Piece] = []
    
    override func didMoveToView(view: SKView) {
        
        /* Setup your scene here */
        
        //Add the initial Pieces
        for i in 0...piecesX-1 {
            for j in 0...piecesY-1 {
                let newPiece = Piece(texture: SKTexture(imageNamed: "Spaceship"), gameScene: self, gridX: i, gridY: j)
                pieces.append(newPiece)
                self.addChild(newPiece)
            }
        }
        
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "\(CGRectGetMaxY(self.frame))  \(CGRectGetMaxX(self.frame))"
        myLabel.fontSize = 16;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.1
            sprite.yScale = 0.1
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
            
            myLabel.text = "\(touch.locationInNode(self))"
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //myLabel.text = "\(CGRectGetMaxY(self.frame))  \(CGRectGetMaxX(self.frame)) \(currentTime)"
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
    }
    
    override func didChangeSize(oldSize: CGSize) {
        myLabel?.text = "\(self.size.height) \(self.size.width)"
        for p in pieces {
            p.reposition()
        }
    }
}
