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

// @CLEANUP: this may just replaced by Position struct
struct PositionerState {
    var currentOffset: Double
}

protocol Positioner {
    // @TODO: should I be passing the entire config struct?
    func update(state: PositionerState, config: GameConfig, targetOffset: Double, dt: Double) -> (PositionerState, [Event])
    // @CLEANUP: really only need to pass in offset, actually positioner state is just the offset
    func getPosition(state: PositionerState, config: GameConfig) -> Position
}

// @TODO: new name for this
class UserPositioner: Positioner {
    func update(state: PositionerState, config: GameConfig, targetOffset: Double, dt: Double) -> (PositionerState, [Event]) {
        let diff = targetOffset - state.currentOffset
        let step = clamp(dt / config.positionerMoveDuration, min: 0.0, max: 1.0)
        let delta = step * diff
        
        let updatedState = PositionerState(currentOffset: state.currentOffset + delta)
        let events = [Event]() // @TODO: implement position events
        
        return (updatedState, events)
    }
    
    func getPosition(state: PositionerState, config: GameConfig) -> Position {
        let nearest = round(state.currentOffset)
        let distance = fabs(state.currentOffset - nearest)
        let within = distance < config.positionerTolerance // @TODO: only allow within if nearest == target
        
        return Position(lane: Int(nearest),
                        offset: state.currentOffset,
                        withinTolerance: within)
    }
}
