//
//  BoardState.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct BoardState {
    var layout: BoardLayout
    var entities: [Entity]
    var position: Double
    var scrollSpeed: Double
    var distanceBetweenEntities: Double
    var lastEntityPosition: Double
}

extension BoardState {
    static func new() -> BoardState {
        return BoardState(layout: BoardLayout.new(),
                          entities: [Entity](),
                          position: 0.0,
                          scrollSpeed: 0.0,
                          distanceBetweenEntities: 0.0,
                          lastEntityPosition: 0.0)
    }
}

struct BoardLayout {
    var playerPosition: Double
    var upperBound: Double
    var lowerBound: Double
}

extension BoardLayout {
    static func new() -> BoardLayout {
        return BoardLayout(playerPosition: 0.0,
                           upperBound: 0.0,
                           lowerBound: 0.0)
    }
}

struct Entity {
    var id: Int
    var position: Double
    var type: EntityType
    var state: EntityState
}

enum EntityType {
    case blank
    case threshold(type: ThresholdType)
    case barrier(gates: [Gate])
}

enum EntityState {
    case none
    case crossed
    case passed
}

enum ThresholdType {
    case roundEnd
    case chunkEnd
}

enum Gate {
    case open
    case closed
}
