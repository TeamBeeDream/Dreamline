//
//  Positioner.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

enum Lane: Int {
    case left   = -1
    case center =  0
    case right  =  1
}

struct Position {
    let lane: Int
    let offset: Double
    let withinTolerance: Bool
}

protocol Positioner {
    func addInput(_ lane: Int)
    func removeInput(count: Int)
    func update(dt: Double, moveDuration: Double);
    func getPosition(tolerance: Double) -> Position
}

class UserPositioner {
    var currentOffset: Double = 0.0
    var targetOffset: Double = 0.0
    var numInputs: Int = 0
}

extension UserPositioner: Positioner {
    func addInput(_ lane: Int) {
        self.targetOffset = Double(lane)
        self.numInputs += 1
    }
    
    func removeInput(count: Int) { // adding a count var allows me to just remove a bunch at once, no more loops
        self.numInputs -= count
        if (self.numInputs == 0) {
            self.targetOffset = Double(Lane.center.rawValue) // this is weird
        }
    }

    func update(dt: Double, moveDuration: Double) {
        let diff: Double = self.targetOffset - self.currentOffset
        let step = clamp(dt / moveDuration, min: 0.0, max: 1.0)
        let delta = step * diff
        self.currentOffset += delta
    }
    
    func getPosition(tolerance: Double) -> Position {
        let nearest = round(self.currentOffset)
        let distance = fabs(self.currentOffset - nearest)
        let within = distance > tolerance
        
        return Position(lane: Int(nearest),
                        offset: self.currentOffset,
                        withinTolerance: within)
    }
}

/* @TODO: build a version of the
 positioner that can be used for tests. */
/*
class MockPositioner : Positioner {
    
}
 */
