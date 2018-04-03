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
    var positionState: PositionState
    var boardState: BoardState
    var focusState: FocusState
}

extension ModelState {
    
    func clone() -> ModelState {
        
        return ModelState(
            positionState: self.positionState,
            boardState: self.boardState,
            focusState: self.focusState)
    }
}

class ModelStateFactory {
    static func getDefault() -> ModelState {
        let layout = BoardLayout(
            spawnPosition: -1.1,
            destroyPosition: 1.1,
            playerPosition: 0.1,
            laneOffset: 0.65)
        
        return ModelState(
            positionState: PositionState(
                offset: 0.0,
                target: 0.0,
                lane: 0,
                withinTolerance: true),
            boardState: BoardStateFactory.getNew(layout: layout),
            focusState: FocusStateFactory.getDefault())
    }
}
