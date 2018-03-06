//
//  Config.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct GameConfig {
    
}

// @TODO: start using state in this struct
static class GameConfigFactory {
    public static func getStandardGame() -> GameConfig {
        return GameConfig()
    }
}
