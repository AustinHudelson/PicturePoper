//
//  PicturePoperGameScene.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/28/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import SpriteKit

class PicturePoperGameScene: SKScene {
    let piecesX = 10
    let piecesY = 10
    let bottomMargin: CGFloat = 64.0
    let topMargin: CGFloat = 64.0
    let leftMargin: CGFloat = 64.0
    let rightMargin: CGFloat = 64.0
    let borderX: CGFloat = 128.0 //Left+Right Margin
    let borderY: CGFloat = 128.0 //Top+Bottom Margin
    var myLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = SKSceneScaleMode.AspectFit
        
        /* Setup your scene here */
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "\(CGRectGetMaxY(self.frame))  \(CGRectGetMaxX(self.frame))"
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        //Add the initial Pieces
        for i in 0...piecesX-1 {
            for j in 0...piecesY-1 {
                let newPiece = Piece(texture: SKTexture(imageNamed: "Spaceship"), gameScene: self, gridX: i, gridY: j)
                self.addChild(newPiece)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
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
    }
}
