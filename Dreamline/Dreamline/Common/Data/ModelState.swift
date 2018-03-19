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
}

extension ModelState {
    
    func clone() -> ModelState {
        
        return ModelState(
            positionState: self.positionState,
            boardState: self.boardState)
    }
}

class ModelStateFactory {
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
            boardState: BoardStateFactory.getNew(layout: layout))
    }
}
