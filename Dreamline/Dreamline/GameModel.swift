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
}

// @TODO: separate user input to usergamemodel protocol
class DebugGameModel: GameModel {
    
    // PROTOCOLS @TODO: set from config
    var positioner: Positioner = UserPositioner()
    var sequencer: Sequencer = RandomSequencer()
    var grid: BarrierGrid = DefaultBarrierGrid()
    
    // STATE @ROBUSTNESS: should i separate this out?
    var positionerState: PositionerState // @TODO: set from config
    var numInputs: Int = 0               // @TODO: move input to its own protocol
    var targetPosition: Double = 0.0     // @TODO: move input to its own protocol
    
    var gridLayout: GridLayout
    var gridState: BarrierGridState
    var distanceSinceLastPattern: Double = 0.0
    var distanceBetweenPatterns: Double = 0.7
    
    init() {
        // @TODO: move to factory
        self.positionerState = PositionerState(
            currentOffset: 0.0,
            tolerance: 0.2,
            moveDuration: 0.1)
        
        // @TODO: move to factory
        self.gridLayout = GridLayout(
            spawnPosition: -0.9,
            destroyPosition: 0.9,
            playerPosition: 0.5,
            laneOffset: 0.65,
            moveSpeed: 1.5)
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
        
        // update grid
        let updatedGridState = self.grid.update(
            state: self.gridState,
            layout: self.gridLayout,
            dt: dt)
        let distance = updatedGridState.totalDistance - self.gridState.totalDistance
        // handle collision
        // @TODO: better naming scheme to handle incremental updates
        // since the grid is likely to be updated multiple times
        // per frame, need some way to manage those steps
        let collisionGridState = self.grid.testCollision(state: updatedGridState, layout: self.gridLayout, position: self.positioner.getPosition(state: self.positionerState))
        
        // update state
        self.positionerState = updatedPositionerState
        self.gridState = collisionGridState
        
        // @HACK: needs to go after gridState update, because I'm manually mutating the state, BAD!
        // if necessary add new patterns to grid
        self.distanceSinceLastPattern += distance
        if (self.distanceSinceLastPattern > self.distanceBetweenPatterns) {
            self.distanceSinceLastPattern = 0.0 // @TODO: better method for positioning barriers
            
            let newBarrier = Barrier(
                pattern: self.sequencer.getNextPattern(),
                position: self.gridLayout.spawnPosition)
            self.gridState.barriers.append(newBarrier) // @FIXME: don't mutate grid state directly
        }
    }
    
    func getPosition() -> Position {
        return self.positioner.getPosition(state: self.positionerState)
    }
    
    func getBarriers() -> BarrierGridState {
        return self.gridState // @FIXME: bug
    }
}
