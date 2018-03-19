//
//  Positioner.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Positioner {
    // @TODO: should I be passing the entire config struct?
    func update(state: PositionState, config: GameConfig, dt: Double) -> (PositionState, [Event])
    // @CLEANUP: really only need to pass in offset, actually positioner state is just the offset
    //func getPosition(state: PositionState, config: GameConfig) -> Position
}

// @TODO: new name for this
class UserPositioner: Positioner {
    func update(state: PositionState, config: GameConfig, dt: Double) -> (PositionState, [Event]) {
        // Calculate new state
        let diff = state.target - state.offset
        let step = clamp(dt / config.positionerMoveDuration, min: 0.0, max: 1.0)
        let delta = step * diff
        
        let updatedOffset = state.offset + delta
        let nearestLane = round(updatedOffset)
        let updatedLane = Int(nearestLane)
        let distance = fabs(updatedOffset - nearestLane)
        let updatedWithin = distance < config.positionerTolerance
        
        // @NOTE: We found that not using clone()
        //        was very hard to read, this is better
        var updatedState = state.clone()
        updatedState.offset = updatedOffset
        updatedState.lane = updatedLane
        updatedState.withinTolerance = updatedWithin
        
        // Generate events
        var events = [Event]()
        let oldPosition = state
        let updatedPosition = calcState(state: updatedState, config: config)
        if oldPosition.lane != updatedPosition.lane {
            events.append(.laneChange)
        }
        
        return (updatedState, events)
    }
    
    private func calcState(state: PositionState, config: GameConfig) -> PositionState {
        let nearest = round(state.offset)
        let distance = fabs(state.offset - nearest)
        let within = distance < config.positionerTolerance // @TODO: only allow within if nearest == target
        
        var updatedState = state.clone()
        updatedState.lane = Int(nearest)
        updatedState.withinTolerance = within
        return updatedState
    }
}
