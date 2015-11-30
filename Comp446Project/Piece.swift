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
    
    private var GScene: PicturePoperGameScene
    private var currentGridX: Int
    private var currentGridY: Int
    private let maxGridX: Int
    private let maxGridY: Int
    private var ID: String
    
    init(texture: SKTexture?, gameScene: PicturePoperGameScene, gridX: Int, gridY: Int) {
        GScene = gameScene
        currentGridX = gridX
        currentGridY = gridY
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
        
        moveToGridPositionInstantly(currentGridX, gridPositionY: currentGridY)
    }
    
    func swipeUp() -> SKAction? {
        if (currentGridY < maxGridY-1) {
            moveToGridPositionOverTime(currentGridX, gridPositionY: currentGridY+1)
        }
        return nil
    }
    
    func swipeDown() -> SKAction? {
        if (currentGridY > 0) {
            moveToGridPositionOverTime(currentGridX, gridPositionY: currentGridY-1)
        }
        return nil
    }
    
    func swipeLeft() -> SKAction? {
        if (currentGridX > 0) {
            moveToGridPositionOverTime(currentGridX-1, gridPositionY: currentGridY)
        }
        return nil
    }
    
    func swipeRight() -> SKAction? {
        if (currentGridX < maxGridX-1) {
            moveToGridPositionOverTime(currentGridX+1, gridPositionY: currentGridY)
        }
        return nil
    }
    
    func destroy() {
        //Animate a destruction
        destroyed = true
    }
    
    //Immediately resizes and places the piece at its current XY grid position in the scene
    func reposition() {
        let dimention = min((CGRectGetMaxX(GScene.frame)-(GScene.borderX))/CGFloat(maxGridX), (CGRectGetMaxY(GScene.frame)-(GScene.borderY))/CGFloat(maxGridY))
        self.size = CGSize(width: dimention, height: dimention)
        moveToGridPositionInstantly(currentGridX, gridPositionY: currentGridY)
    }
    
    private func moveToGridPositionInstantly(gridPositionX: Int, gridPositionY: Int){
        currentGridX = gridPositionX
        currentGridY = gridPositionY
        let newX = (CGFloat(currentGridX) * self.size.width)+(self.size.width/2.0)+GScene.leftMargin
        let newY = CGRectGetMaxY(GScene.frame)-((CGFloat(currentGridY) * self.size.height)+(self.size.height/2.0)+GScene.topMargin)
        self.position = CGPoint(x:newX, y:newY)
    }
    
    //Returns the SKAction of the move animation
    private func moveToGridPositionOverTime(gridPositionX: Int, gridPositionY: Int) -> SKAction? {
        currentGridX = gridPositionX
        currentGridY = gridPositionY
        let newX = (CGFloat(currentGridX) * self.size.width)+(self.size.width/2.0)+GScene.leftMargin
        let newY = CGRectGetMaxY(GScene.frame)-((CGFloat(currentGridY) * self.size.height)+(self.size.height/2.0)+GScene.topMargin)
        self.position = CGPoint(x:newX, y:newY)
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}