//
//  CollisionHelper.swift
//  Dreamline
//
//  Created by BeeDream on 4/10/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @RENAME: This name is really long :(
class Collision {
    static func didCrossLine(testPosition: Double,
                             linePosition: Double,
                             lineDelta: Double) -> Bool {
        
        return
            (testPosition < linePosition) &&
            (testPosition > linePosition - lineDelta)
    }
    
    static func inArea(testPosition: Double,
                       areaLowerBound: Double,
                       areaUpperBound: Double) -> Bool {
        return
            (testPosition > areaLowerBound) &&
            (testPosition < areaUpperBound)
    }
}
