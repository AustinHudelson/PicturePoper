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
    
    private var currentGridX: Int
    private var currentGridY: Int
    private let maxGridX: Int
    private let maxGridY: Int
    private var ID: String
    
    init(texture: SKTexture?, color: UIColor, gameScene: PicturePoperGameScene, gridX: Int, gridY: Int) {
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
        let dimention = min(gameScene.size.width/CGFloat(maxGridX), gameScene.size.height/CGFloat(maxGridY))
        super.init(texture: texture, color: color, size: CGSize(width: dimention, height: dimention))
    }
    
    func swipeUp() {
        
    }
    
    func swipeDown() {
        
    }
    
    func swipeLeft() {
        
    }
    
    func swipeRight() {
        
    }
    
    func destroy() {
        //Animate a destruction
        destroyed = true
    }
    
    private func moveTo(gridPositionX: Int, gridPositionY: Int){
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}