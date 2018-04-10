//
//  Board.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct BoardData {
    
    // MARK: Properties
    
    var entities: [Int: EntityData]
    var layout: BoardLayout
    var scrollDistance: Double

    // MARK: Static Constructors
    
    static func new() -> BoardData {
        return BoardData(entities: [Int: EntityData](),
                         layout: BoardLayout.new(),
                         scrollDistance: 0.0)
    }
    
    static func clone(_ data: BoardData) -> BoardData {
        return BoardData(entities: data.entities,
                         layout: data.layout,
                         scrollDistance: data.scrollDistance)
    }
}

struct BoardLayout {
    
    // MARK: Properties
    
    var playerPosition: Double
    var upperBound: Double
    var lowerBound: Double
    var distanceBetweenLanes: Double
    var distanceBetweenEntities: Double
    
    // MARK: Static Constructors
    
    static func new() -> BoardLayout {
        // @HARDCODED
        return BoardLayout(playerPosition: 0.2,
                           upperBound: 1.0,
                           lowerBound: -1.0,
                           distanceBetweenLanes: 0.5,
                           distanceBetweenEntities: 0.5)
    }
    
    static func clone(_ data: BoardLayout) -> BoardLayout {
        return BoardLayout(playerPosition: data.playerPosition,
                           upperBound: data.upperBound,
                           lowerBound: data.lowerBound,
                           distanceBetweenLanes: data.distanceBetweenLanes,
                           distanceBetweenEntities: data.distanceBetweenEntities)
    }
}
