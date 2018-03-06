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
    
    // PROTOCOLS
    var positioner: Positioner = UserPositioner()
    var sequencer: Sequencer = DefaultSequencer()
    var grid: BarrierGrid = DefaultBarrierGrid()
    
    // STATE
    // positioner
    var positionerState: PositionerState // @TODO: set from config
    var numInputs: Int = 0               // @TODO: move input to its own protocol
    var targetPosition: Double = 0.0     // @TODO: move input to its own protocol
    
    // sequencer
    var gridProperties: GridProperties
    var gridState: BarrierGridState
    var timeBetweenPatterns: Double = 0.1
    var timeSinceLastPattern: Double = 0.0
    var patternSource: PatternSource
    var patternOptions: PatternOptions
    
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
        
        // @FIXME: this is test data, define somewhere else
        var patterns = [Int: [Pattern]]()
        patterns[0] = [Pattern]()
        patterns[0]!.append(Pattern(data: [.closed, .closed, .closed]))
        patterns[0]!.append(Pattern(data: [.closed,   .open, .closed]))
        patterns[0]!.append(Pattern(data: [.closed,   .open,   .open]))
        self.patternSource = PatternSource(patterns: patterns)
        self.patternOptions = PatternOptions(groupCount: 1, groupLength: 1, difficulty: 0)
        
        // @HACK: debug: add a bunch of barriers to the grid
        let generatedPatterns = self.sequencer.generatePatterns(source: self.patternSource, options: self.patternOptions)
        for (i, pattern) in generatedPatterns.enumerated() {
            let offset = Double(i) * 0.2
            self.gridState.barriers.append(Barrier(pattern: pattern, position: self.gridProperties.spawnPosition - offset)) // @FIXME: this is weird
        }
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
        self.positionerState = updatedPositionerState
        
        // update sequencer
        let updatedGridState = self.grid.update(
            state: self.gridState,
            properties: self.gridProperties,
            dt: dt)
        // @NOTE: have room to compare states before updating
        self.gridState = updatedGridState
        
        // @TODO: implement adding new barriers to grid
        // could be time based or distance based
    }
    
    func getPosition() -> Position {
        return self.positioner.getPosition(state: self.positionerState)
    }
    
    func getBarriers() -> BarrierGridState {
        return self.gridState // @FIXME: bug
    }
}
