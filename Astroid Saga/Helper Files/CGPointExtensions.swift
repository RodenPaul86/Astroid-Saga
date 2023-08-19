//
//  CGPointExtensions.swift
//  Astroid Saga
//
//  Created by Paul on 10/17/19.
//  Copyright © 2019 Studio4Designsoftware. All rights reserved.
//

import UIKit

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

extension CGPoint {
    static var upperLeft: CGPoint {
        return CGPoint(x: 0, y: 1)
    }
    
    static var upperCenter: CGPoint {
        return CGPoint(x: 0.5, y: 1)
    }
    
    static var upperRight: CGPoint {
        return CGPoint(x: 1, y: 1)
    }
    
    static var middleLeft: CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }
    
    static var middleCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0.5)
    }
    
    static var middleRight: CGPoint {
        return CGPoint(x: 1, y: 0.5)
    }
    
    static var lowerLeft: CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    static var lowerCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0)
    }
    
    static var lowerRight: CGPoint {
        return CGPoint(x: 1, y: 0)
    }
}
