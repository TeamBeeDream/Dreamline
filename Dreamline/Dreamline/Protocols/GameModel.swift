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
    // @NOTE: This is doing many things, maybe it should
    // be broken up?
    func update(state: ModelState,
                config: GameConfig,
                ruleset: Ruleset,
                positioner: Positioner,
                board: Board,
                sequencer: Sequencer,
                focus: Focus,
                dt: Double) -> (ModelState, [Event])
}

class DefaultGameModel: GameModel {
    func update(state: ModelState,
                config: GameConfig,
                ruleset: Ruleset,
                positioner: Positioner,
                board: Board,
                sequencer: Sequencer,
                focus: Focus,
                dt: Double) -> (ModelState, [Event]) {
        
        var updatedState = state.clone()
        var raisedEvents = [Event]()
        
        // Update positioner
        let (updatedPositionState, positionEvents) = positioner.update(
            state: state.positionState,
            config: config,
            dt: dt)
        updatedState.positionState = updatedPositionState
        raisedEvents.append(contentsOf: positionEvents)
        
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
        updatedState.boardState = updatedBoardState
        raisedEvents.append(contentsOf: boardEvents)
        
        // Update focus
        let (updatedFocusState, focusEvents) = focus.update(
            state: state.focusState,
            dt: dt,
            events: raisedEvents,
            config: config)
        updatedState.focusState = updatedFocusState
        raisedEvents.append(contentsOf: focusEvents)
        
        // Return updated state with all raised events
        return (updatedState, raisedEvents)
        
        // @NOTE: Interestingly, these all follow the same format, so this might
        // be a candidate for something like an ECS where you just pop in different
        // modules that each update and the events and state automatically composite
        // The benefit of this is that the order is specified
    }
}
