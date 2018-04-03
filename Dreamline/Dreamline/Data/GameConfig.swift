//
//  GameConfig.swift
//  Dreamline
//
//  Created by BeeDream on 3/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @RENAME, maybe 'GameModifiers', 'Mutations' ...
struct GameConfig {
    var positionerTolerance: Double
    var positionerMoveDuration: Double
    
    var boardScrollSpeed: Speed
    var boardDistanceBetweenEntities: Double
    
    var pointsPerBarrier: Int
    
    var focusDelay: Double
    var focusMaxLevel: Int
}

extension GameConfig {
    func clone() -> GameConfig {
        return GameConfig(
            positionerTolerance: self.positionerTolerance,
            positionerMoveDuration: self.positionerMoveDuration,
            boardScrollSpeed: self.boardScrollSpeed,
            boardDistanceBetweenEntities: self.boardDistanceBetweenEntities,
            pointsPerBarrier: self.pointsPerBarrier,
            focusDelay: self.focusDelay,
            focusMaxLevel: self.focusMaxLevel)
    }
}

class GameConfigFactory {
    static func getDefault() -> GameConfig {
        return GameConfig(
            positionerTolerance: 0.2,
            positionerMoveDuration: 0.1,
            boardScrollSpeed: .mach3,
            boardDistanceBetweenEntities: 0.7,
            pointsPerBarrier: 1,
            focusDelay: 3.0,
            focusMaxLevel: 3)
    }
    
    // @CLEANUP: This should probably be in DreamlineTests
    static func getMock() -> GameConfig {
        return GameConfig(
            positionerTolerance: 0.0,
            positionerMoveDuration: 0.0,
            boardScrollSpeed: .mach1,
            boardDistanceBetweenEntities: 0.0,
            pointsPerBarrier: 0,
            focusDelay: 0.0,
            focusMaxLevel: 1)
    }
}
