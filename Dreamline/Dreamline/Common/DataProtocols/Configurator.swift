//
//  Configurator.swift
//  Dreamline
//
//  Created by BeeDream on 3/15/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Configurator {
    func updateConfig(config: GameConfig, ruleset: Ruleset, events: [Event]) -> GameConfig
}


class DefaultConfigurator: Configurator {
    func updateConfig(config: GameConfig, ruleset: Ruleset, events: [Event]) -> GameConfig {
        var updatedConfig = config.clone()
        for event in events {
            switch (event) {
            case .modifierGet(_, let type):
                updatedConfig.boardScrollSpeed = newSpeed(current: config.boardScrollSpeed, table: ruleset.speedLookup, modifier: type)
            default:
                break
            }
        }
        return updatedConfig
    }
    
    private func newSpeed(current: Speed,
                          table: [Speed: SpeedInfo],
                          modifier: ModifierType) -> Speed {
        switch modifier {
        case .none:
            return current
        case .speedUp:
            let index = clamp(current.rawValue + 1, min: 0, max: Speed.count-1)
            return Speed(rawValue: index)!
        case .speedDown:
            let index = clamp(current.rawValue - 1, min: 0, max: Speed.count-1)
            return Speed(rawValue: index)!
        }
    }
}
