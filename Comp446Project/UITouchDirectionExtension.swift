//
//  UITouchDirectionExtension.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/29/15.
//  Copyright © 2015 Austin Hudelson. All rights reserved.
//

import UIKit
extension UITouch
{
    //Determines the direction of a UI Touch from a specific origin. "Up" "Down" "Left" "Right"
    //String temporarially used as an enum
    func touchDirectionFromPoint(origin: CGPoint, inView: UIView) -> String {
        let currentPoint = self.locationInView(inView)
        //Determine if the swipe is more vert or horisontal
        let xDiff = currentPoint.x - origin.x
        let yDiff = currentPoint.y - origin.y
        if xDiff > yDiff {
            //Horisontal
            if xDiff > 0 {
                //right swipe
                return "Right"
            } else {
                return "Left"
            }
        } else {
            //Vertical
            if yDiff > 0 {
                return "Up"
            } else {
                return "Down"
            }
            
        }
    }
}