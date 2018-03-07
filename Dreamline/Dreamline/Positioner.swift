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

// @CLEANUP: maybe combine with PositionerState
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
    func update(state: PositionerState, targetOffset: Double, dt: Double) -> (PositionerState, [Event])
    func getPosition(state: PositionerState) -> Position
}

// @TODO: new name for this
class UserPositioner: Positioner {
    func update(state: PositionerState, targetOffset: Double, dt: Double) -> (PositionerState, [Event]) {
        let diff = targetOffset - state.currentOffset
        let step = clamp(dt / state.moveDuration, min: 0.0, max: 1.0)
        let delta = step * diff
        
        let updatedState = PositionerState(
            currentOffset: state.currentOffset + delta,
            tolerance: state.tolerance,
            moveDuration: state.moveDuration)
        let events = [Event]() // @TODO: implement position events
        
        return (updatedState, events)
    }
    
    func getPosition(state: PositionerState) -> Position {
        let nearest = round(state.currentOffset)
        let distance = fabs(state.currentOffset - nearest)
        let within = distance < state.tolerance // @TODO: only allow within if nearest == target
        
        return Position(lane: Int(nearest),
                        offset: state.currentOffset,
                        withinTolerance: within)
    }
}
