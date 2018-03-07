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
    
    var board: Board
    var boardState: BoardState
    var boardLayout: BoardLayout
    
    var sequencer: Sequencer
}

extension ModelState {
    func clone() -> ModelState {
        return ModelState(
            positioner: self.positioner,
            positionerState: self.positionerState,
            targetOffset: self.targetOffset,
            
            board: self.board,
            boardState: self.boardState,
            boardLayout: self.boardLayout,
            
            sequencer: self.sequencer)
    }
}

// @TODO: convert this to a factory class
extension ModelState {
    // @CLEANUP: temp factory method
    static func getDefault() -> ModelState {
        return ModelState(
            positioner: UserPositioner(),
            positionerState: PositionerState(
                currentOffset: 0.0),
            targetOffset: 0.0,
            board: DefaultBoard(),
            boardState: BoardState(
                distanceBetweenBarriers: 0.7),
            boardLayout: BoardLayout(
                spawnPosition: -1.1,
                destroyPosition: 1.1,
                playerPosition: 0.5,
                laneOffset: 0.65),
            sequencer: RandomSequencer())
    }
}

protocol GameModel {
    // @TODO: add ruleset
    func update(state: ModelState, config: GameConfig, dt: Double) -> (ModelState, [Event])
}

// @TODO: rename
class DefaultGameModel: GameModel {
    func update(state: ModelState, config: GameConfig, dt: Double) -> (ModelState, [Event]) {
        
        // Update positioner
        let (updatedPositionerState, positionEvents) = state.positioner.update(
            state: state.positionerState,
            config: config,
            targetOffset: state.targetOffset,
            dt: dt)
        
        // Update board
        let (updatedBoardState, boardEvents) = state.board.update(
            state: state.boardState,
            config: config,
            layout: state.boardLayout,
            sequencer: state.sequencer,
            position: state.positioner.getPosition(
                state: updatedPositionerState,
                config: config),
            dt: dt)
        
        // Composite updated states
        var updatedState = state.clone()
        updatedState.positionerState = updatedPositionerState
        updatedState.boardState = updatedBoardState
        
        // Composite events
        var allEvents = [Event]()
        allEvents.append(contentsOf: positionEvents)
        allEvents.append(contentsOf: boardEvents)
        
        return (updatedState, allEvents)
    }
}
