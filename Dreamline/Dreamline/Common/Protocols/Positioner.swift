//
//  Positioner.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Positioner {
    func update(state: PositionState, config: GameConfig, dt: Double) -> (PositionState, [Event])
}

class DefaultPositioner: Positioner {
    func update(state: PositionState, config: GameConfig, dt: Double) -> (PositionState, [Event]) {
        // Calculate difference since last update
        let diff = state.target - state.offset
        let step = clamp(dt / config.positionerMoveDuration, min: 0.0, max: 1.0)
        let delta = step * diff
        
        // Calculate new position state
        let updatedOffset = state.offset + delta
        let nearestLane = round(updatedOffset)
        let updatedLane = Int(nearestLane)
        let distance = fabs(updatedOffset - nearestLane)
        let updatedWithin = distance < config.positionerTolerance
        
        // Update state
        var updatedState = state.clone()
        updatedState.offset = updatedOffset
        updatedState.lane = updatedLane
        updatedState.withinTolerance = updatedWithin
        
        // Generate events
        var events = [Event]()
        let oldPosition = state
        if oldPosition.lane != updatedLane {
            events.append(.laneChange)
        }
        
        return (updatedState, events)
    }
}
