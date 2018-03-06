//
//  GameModel.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol GameModel {
    func addInput(_ lane: Int)
    func removeInput(count: Int)
    func update(dt: Double)
    func getPosition() -> Position
}

// @TODO: separate user input to usergamemodel protocol
class DebugGameModel: GameModel {
    
    // PROTOCOLS
    var positioner: Positioner = UserPositioner()
    
    // STATE
    var positionerState: PositionerState // @TODO: set from config
    var numInputs: Int = 0               // @TODO: move input to its own protocol
    var targetPosition: Double = 0.0     // @TODO: move input to its own protocol
    
    init() {
        self.positionerState = PositionerState(
            currentOffset: 0.0,
            tolerance: 0.1,
            moveDuration: 0.1)
    }
    
    func addInput(_ lane: Int) {
        self.targetPosition = Double(lane)
        self.numInputs += 1
    }
    
    func removeInput(count: Int) {
        self.numInputs -= count
        if (self.numInputs == 0) {
            self.targetPosition = 0.0
        }
    }
    
    func update(dt: Double) {
        let updatedState = self.positioner.update(
            state: self.positionerState,
            targetOffset: self.targetPosition,
            dt: dt)
        // @NOTE: interesting intermediate step where we have both the old and the
        // new states that we can compare/cache/etc...
        self.positionerState = updatedState
    }
    
    func getPosition() -> Position {
        return self.positioner.getPosition(state: self.positionerState)
    }
}
