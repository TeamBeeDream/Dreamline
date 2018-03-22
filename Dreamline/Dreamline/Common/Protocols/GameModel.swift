//
//  GameModel.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

/**
 Main update tick for game
 */
protocol GameModel {
    func update(state: ModelState,
                config: GameConfig,
                ruleset: Ruleset,
                positioner: Positioner,
                board: Board,
                sequencer: Sequencer,
                dt: Double) -> (ModelState, [Event])
}

class DefaultGameModel: GameModel {
    func update(state: ModelState,
                config: GameConfig,
                ruleset: Ruleset,
                positioner: Positioner,
                board: Board,
                sequencer: Sequencer,
                dt: Double) -> (ModelState, [Event]) {
        
        // Update positioner
        let (updatedPositionState, positionEvents) = positioner.update(
            state: state.positionState,
            config: config,
            dt: dt)
        
        // Update board
        let (updatedBoardState, boardEvents) = board.update(
            state: state.boardState,
            config: config,
            ruleset: ruleset,
            sequencer: sequencer,
            positioner: positioner,
            originalPosition: state.positionState,
            updatedPosition: updatedPositionState,
            dt: dt)
        
        // Composite updated states
        var updatedState = state.clone()
        updatedState.positionState = updatedPositionState
        updatedState.boardState = updatedBoardState
        
        // Composite events
        var allEvents = [Event]()
        allEvents.append(contentsOf: positionEvents)
        allEvents.append(contentsOf: boardEvents)
        
        return (updatedState, allEvents)
    }
}
