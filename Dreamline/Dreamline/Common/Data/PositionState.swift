//
//  PositionState.swift
//  Dreamline
//
//  Created by BeeDream on 3/14/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

enum Lane: Int {
    case left   = -1
    case center =  0
    case right  =  1
}

struct PositionState {
    var offset: Double
    var target: Double
    
    var lane: Int
    var withinTolerance: Bool
}

extension PositionState {
    // @NOTE: 'duplicate' is pretty cool...
    func clone() -> PositionState {
        return PositionState(offset: self.offset,
                             target: self.target,
                             lane: self.lane,
                             withinTolerance: self.withinTolerance)
    }
    
    mutating func setTarget(_ lane: Lane) {
        self.target = Double(lane.rawValue)
    }
}
