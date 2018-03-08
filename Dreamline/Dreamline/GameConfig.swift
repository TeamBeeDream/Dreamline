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
    
    var boardScrollSpeed: Double // @TODO: min and max speed
}

extension GameConfig {
    func clone() -> GameConfig {
        return GameConfig(
            positionerTolerance: self.positionerTolerance,
            positionerMoveDuration: self.positionerMoveDuration,
            boardScrollSpeed: self.boardScrollSpeed)
    }
}

class GameConfigFactory {
    static func getDefault() -> GameConfig {
        return GameConfig(
            positionerTolerance: 0.2,
            positionerMoveDuration: 0.1,
            boardScrollSpeed: 1.0)
    }
}
