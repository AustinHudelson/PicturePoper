//
//  PieceGridPosition.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/29/15.
//  Copyright © 2015 Austin Hudelson. All rights reserved.
//

import Foundation
//Basically just a wraper class for a tuple with two numbers
class PieceGridPosition {
    static let maxX: Int = 5 //Indexing begins at 0 so add 1 for number of rows/columns
    static let maxY: Int = 5
    var x: Int
    var y: Int
    
    init?(x: Int, y: Int){
        self.x = x
        self.y = y
        if (x > PieceGridPosition.maxX || x < 0 || y > PieceGridPosition.maxY || y < 0){
            return nil
        }
    }
    
    func getLeftPosition() -> PieceGridPosition? {
        if x > 0 {
            return PieceGridPosition(x: x-1, y: y)
        }
        return nil
    }
    
    func getRightPosition() -> PieceGridPosition? {
        if x < PieceGridPosition.maxX {
            return PieceGridPosition(x: x+1, y: y)
        }
        return nil
    }
    
    func getAbovePosition() -> PieceGridPosition? {
        if y > 0 {
            return PieceGridPosition(x: x, y: y-1)
        }
        return nil
    }
    
    func getBelowPosition() -> PieceGridPosition? {
        if y < PieceGridPosition.maxY {
            return PieceGridPosition(x: x, y: y+1)
        }
        return nil
    }
    
    func copy() -> PieceGridPosition {
        return PieceGridPosition(x: self.x, y: self.y)!
    }
}