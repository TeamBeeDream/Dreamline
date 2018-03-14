//
//  ModelState.swift
//  Dreamline
//
//  Created by BeeDream on 3/14/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @RENAME: Needs a name that implies that this is the state
//          of only the things related to position and board
struct ModelState {
    // @NOTE: Maybe the ModelState shouldn't contain both
    //        state and the protocols that mutate it
    
    var positionState: PositionState        // @State (includes targetOffset)
    var boardState: BoardState                  // @State

    // Should this be here at all?
    var positioner: Positioner                  // @Protocol
    var board: Board                            // @Protocol
    var sequencer: Sequencer                    // @Protocol
}

extension ModelState {
    
    func clone() -> ModelState {
        
        return ModelState(
            positionState: self.positionState,
            boardState: self.boardState,
            
            positioner: self.positioner,
            board: self.board,
            sequencer: self.sequencer)
    }
}

// @TODO: convert this to a factory class
extension ModelState {
    
    // @CLEANUP: temp factory method
    static func getDefault() -> ModelState {
        let layout = BoardLayout(
            spawnPosition: -1.1,
            destroyPosition: 1.1,
            playerPosition: 0.5,
            laneOffset: 0.65)
        return ModelState(
            positionState: PositionState(
                offset: 0.0,
                target: 0.0,
                lane: 0,
                withinTolerance: true),
            boardState: BoardState(layout: layout),
            positioner: UserPositioner(),
            board: DefaultBoard(),
            sequencer: AuthoredSequencer())
    }
}
