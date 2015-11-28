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
    var myLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "\(CGRectGetMaxY(self.frame))  \(CGRectGetMaxX(self.frame))"
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
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
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        myLabel.text = "\(CGRectGetMaxY(self.frame))  \(CGRectGetMaxX(self.frame)) \(currentTime)"
    }
}
