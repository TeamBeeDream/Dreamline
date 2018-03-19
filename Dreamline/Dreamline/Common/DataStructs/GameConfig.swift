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
    var boardDistanceBetweenTriggers: Double
}

extension GameConfig {
    func clone() -> GameConfig {
        return GameConfig(
            positionerTolerance: self.positionerTolerance,
            positionerMoveDuration: self.positionerMoveDuration,
            boardScrollSpeed: self.boardScrollSpeed,
            boardDistanceBetweenTriggers: self.boardDistanceBetweenTriggers)
    }
}

class GameConfigFactory {
    static func getDefault() -> GameConfig {
        return GameConfig(
            positionerTolerance: 0.2,
            positionerMoveDuration: 0.1,
            boardScrollSpeed: .mach1,
            boardDistanceBetweenTriggers: 0.7)
    }
}
