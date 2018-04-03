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
    
    var discreteRounds: Bool
    
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
            discreteRounds: self.discreteRounds,
            focusDelay: self.focusDelay,
            focusMaxLevel: self.focusMaxLevel)
    }
}

class GameConfigFactory {
    static func getChallengeConfig() -> GameConfig {
        return GameConfig(
            positionerTolerance: 0.2,
            positionerMoveDuration: 0.1,
            boardScrollSpeed: .mach3,
            boardDistanceBetweenEntities: 0.7,
            pointsPerBarrier: 1,
            discreteRounds: false,
            focusDelay: 5.0,
            focusMaxLevel: 3)
    }
    
    static func getMeditationConfig() -> GameConfig {
        return GameConfig(
            positionerTolerance: 0.2,
            positionerMoveDuration: 0.1,
            boardScrollSpeed: .mach3,
            boardDistanceBetweenEntities: 0.7,
            pointsPerBarrier: 1,
            discreteRounds: true,
            focusDelay: 5.0,
            focusMaxLevel: 3)
    }
}
