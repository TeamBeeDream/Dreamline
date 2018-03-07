//
//  GameModel.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @TODO: rename
struct ModelState {
    var positioner: Positioner
    var positionerState: PositionerState
    var targetOffset: Double
    
    var grid: BarrierGrid
    var gridState: BarrierGridState
    var gridLayout: GridLayout
    
    var sequencer: Sequencer
}

extension ModelState {
    func clone() -> ModelState {
        return ModelState(
            positioner: self.positioner,
            positionerState: self.positionerState,
            targetOffset: self.targetOffset,
            grid: self.grid,
            gridState: self.gridState,
            gridLayout: self.gridLayout,
            sequencer: self.sequencer)
    }
}

extension ModelState {
    // @CLEANUP: temp factory method
    static func getDefault() -> ModelState {
        return ModelState(
            positioner: UserPositioner(),
            positionerState: PositionerState(
                currentOffset: 0.0,
                tolerance: 0.2,
                moveDuration: 0.1),
            targetOffset: 0.0,
            grid: DefaultBarrierGrid(),
            gridState: BarrierGridState(
                barriers: [Barrier](),
                totalDistance: 0.0,
                distanceSinceLastBarrier: 0.0,
                distanceBetweenBarriers: 0.7),
            gridLayout: GridLayout(
                spawnPosition: -0.9,
                destroyPosition: 0.9,
                playerPosition: 0.5,
                laneOffset: 0.65,
                moveSpeed: 1.2),
            sequencer: RandomSequencer())
    }
}

protocol GameModel {
    /*
    func addInput(_ lane: Int)
    func removeInput(count: Int)
     */
    // @TODO: add ruleset
    func update(state: ModelState, dt: Double) -> (ModelState, [Event])
 
    // @TODO: remove these, model doesn't hold state
    //func getPosition() -> Position
    //func getBarriers() -> BarrierGridState
}

// @TODO: rename
class DefaultGameModel: GameModel {
    func update(state: ModelState, dt: Double) -> (ModelState, [Event]) {
        // steps:
        // 0? handle input
        // 1. update positioner
        // 2. update grid
        // 3. handle collisions
        // 4. composite updated state and events
        
        let (updatedPositionerState, positionEvents) = state.positioner.update(
            state: state.positionerState,
            targetOffset: state.targetOffset,
            dt: dt)
        
        let (updatedGridState, gridEvents) = state.grid.update(
            state: state.gridState,
            layout: state.gridLayout,
            sequencer: state.sequencer,
            position: state.positioner.getPosition(state: updatedPositionerState),
            dt: dt)
        
        var updatedState = state.clone()
        updatedState.positionerState = updatedPositionerState
        updatedState.gridState = updatedGridState
        
        var allEvents = [Event]()
        allEvents.append(contentsOf: positionEvents)
        allEvents.append(contentsOf: gridEvents)
        
        return (updatedState, allEvents)
    }
}

/*
class DebugGameModel: GameModel {
    
    // PROTOCOLS @TODO: set from config
    var positioner: Positioner = UserPositioner()
    var sequencer: Sequencer = RandomSequencer()
    var grid: BarrierGrid = DefaultBarrierGrid()
    
    // EVENT LISTENERS
    var listeners = [EventListener]()
    
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
    
    // @TODO: implement event handling
    // maybe update interfaces take in state and return (updated state, and [Event])
    // so events are always bubbled up, but each step can respond to it if it needs to
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
        return self.gridState
    }
}
 */
