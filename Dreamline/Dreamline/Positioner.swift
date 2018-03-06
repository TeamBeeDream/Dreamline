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

struct PositionerState {
    var currentOffset: Double
    var tolerance: Double
    var moveDuration: Double
}

protocol Positioner {
    func update(state: PositionerState, targetOffset: Double, dt: Double) -> PositionerState
    func getPosition(state: PositionerState) -> Position
}

// @TODO: new name for this
class UserPositioner: Positioner {
    func update(state: PositionerState, targetOffset: Double, dt: Double) -> PositionerState {
        let diff = targetOffset - state.currentOffset
        let step = clamp(dt / state.moveDuration, min: 0.0, max: 1.0)
        let delta = step * diff
        
        return PositionerState(
            currentOffset: state.currentOffset + delta,
            tolerance: state.tolerance,
            moveDuration: state.moveDuration)
    }
    
    func getPosition(state: PositionerState) -> Position {
        let nearest = round(state.currentOffset)
        let distance = fabs(state.currentOffset - nearest)
        let within = distance > state.tolerance
        
        return Position(lane: Int(nearest),
                        offset: state.currentOffset,
                        withinTolerance: within)
    }
}
