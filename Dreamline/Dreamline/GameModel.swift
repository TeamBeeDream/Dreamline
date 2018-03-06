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
    func getBarriers() -> BarrierGridState // @FIXME: is this good?
    // MAYBE ALL STATE SHOULD BE REMOVE FROM MODEL??
}

// @TODO: separate user input to usergamemodel protocol
class DebugGameModel: GameModel {
    
    // PROTOCOLS @TODO: set from config
    var positioner: Positioner = UserPositioner()
    var sequencer: Sequencer = RandomSequencer()
    var grid: BarrierGrid = DefaultBarrierGrid()
    
    // STATE
    // positioner
    var positionerState: PositionerState // @TODO: set from config
    var numInputs: Int = 0               // @TODO: move input to its own protocol
    var targetPosition: Double = 0.0     // @TODO: move input to its own protocol
    
    // sequencer
    var gridProperties: GridProperties
    var gridState: BarrierGridState
    var distanceSinceLastPattern: Double = 0.0
    var distanceBetweenPatterns: Double = 0.7
    
    init() {
        // @TODO: move to factory
        self.positionerState = PositionerState(
            currentOffset: 0.0,
            tolerance: 0.1,
            moveDuration: 0.1)
        
        // @TODO: move to factory
        self.gridProperties = GridProperties(
            spawnPosition: -1.0,
            destroyPosition: 1.0,
            moveSpeed: 0.75)
        self.gridState = BarrierGridState(
            barriers: [Barrier](),
            totalDistance: 0.0)
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
        // update positioner
        let updatedPositionerState = self.positioner.update(
            state: self.positionerState,
            targetOffset: self.targetPosition,
            dt: dt)
        // @NOTE: interesting intermediate step where we have both the old and the
        // new states that we can compare/cache/etc...
        self.positionerState = updatedPositionerState // @TODO: maybe update at end of method
        
        // update sequencer
        let updatedGridState = self.grid.update(
            state: self.gridState,
            properties: self.gridProperties,
            dt: dt)
        // @NOTE: have room to compare states before updating
        let distance = updatedGridState.totalDistance - self.gridState.totalDistance
        self.gridState = updatedGridState // @TODO: maybe update at end of method
        
        // if necessary add new patterns to grid
        self.distanceSinceLastPattern += distance
        if (self.distanceSinceLastPattern > self.distanceBetweenPatterns) {
            self.distanceSinceLastPattern = 0.0 // @TODO: better method for positioning barriers
            
            let newBarrier = Barrier(
                pattern: self.sequencer.getNextPattern(),
                position: self.gridProperties.spawnPosition)
            self.gridState.barriers.append(newBarrier)
        }
    }
    
    func getPosition() -> Position {
        return self.positioner.getPosition(state: self.positionerState)
    }
    
    func getBarriers() -> BarrierGridState {
        return self.gridState // @FIXME: bug
    }
}
