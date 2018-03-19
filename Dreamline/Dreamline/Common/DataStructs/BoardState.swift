//
//  BoardState.swift
//  Dreamline
//
//  Created by BeeDream on 3/14/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

/**
 Positions on the board
 @TODO: Explain relative coordinate system
 */
struct BoardLayout {
    var spawnPosition: Double
    var destroyPosition: Double
    var playerPosition: Double
    var laneOffset: Double
}

/**
 The complete state of the board
 */
struct BoardState {
    var entities: [Entity]
    var totalDistance: Double
    var distanceSinceLastEntity: Double
    var totalEntityCount: Int // @CLEANUP: this is used for assigning unique int ids
    var layout: BoardLayout
}

extension BoardState {
    func clone() -> BoardState {
        return BoardState(entities: self.entities,
                          totalDistance: self.totalDistance,
                          distanceSinceLastEntity: self.distanceSinceLastEntity,
                          totalEntityCount: self.totalEntityCount,
                          layout: self.layout)
    }
}

class BoardStateFactory {
    static func getNew(layout: BoardLayout) -> BoardState {
        return BoardState(entities: [Entity](),
                          totalDistance: 0.0,
                          distanceSinceLastEntity: 0.0,
                          totalEntityCount: 0,
                          layout: layout)
    }
}
