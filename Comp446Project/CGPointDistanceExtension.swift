//
//  CGPointDistanceExtension.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/29/15.
//  Copyright © 2015 Austin Hudelson. All rights reserved.
//

import UIKit
import Foundation
extension CGPoint
{
    //Returns the difference between two CGPoints
    static func getDistance(p1: CGPoint, p2: CGPoint)->CGFloat{
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        return sqrt((dx*dx)+(dy*dy))
    }
}