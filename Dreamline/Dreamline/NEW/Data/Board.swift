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
    
    var entities: [EntityData]
    var layout: BoardLayout
    var scrollDistance: Double
    //var scrollSpeed: Double

    // MARK: Static Constructors
    
    static func new() -> BoardData {
        return BoardData(entities: [EntityData](),
                         layout: BoardLayout.new(),
                         scrollDistance: 0.0)
                         //scrollSpeed: 0.0)
    }
    
    static func clone(_ data: BoardData) -> BoardData {
        return BoardData(entities: data.entities,
                         layout: data.layout,
                         scrollDistance: data.scrollDistance)
                         //scrollSpeed: data.scrollSpeed)
    }
}

struct BoardLayout {
    
    // MARK: Properties
    
    var playerOffset: Double
    var upperBound: Double
    var lowerBound: Double
    var distanceBetweenLanes: Double
    
    // MARK: Static Constructors
    
    static func new() -> BoardLayout {
        return BoardLayout(playerOffset: 0.0,
                           upperBound: 1.0,
                           lowerBound: -1.0,
                           distanceBetweenLanes: 0.5)
    }
    
    static func clone(_ data: BoardLayout) -> BoardLayout {
        return BoardLayout(playerOffset: data.playerOffset,
                           upperBound: data.upperBound,
                           lowerBound: data.lowerBound,
                           distanceBetweenLanes: data.distanceBetweenLanes)
    }
}
