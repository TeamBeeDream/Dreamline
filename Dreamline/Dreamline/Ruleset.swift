//
//  Ruleset.swift
//  Dreamline
//
//  Created by BeeDream on 3/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct Ruleset {
    var speedIncreaseMultiplier: Double
    var speedDecreaseMultiplier: Double
}

class RulesetFactory {
    static func getDefault() -> Ruleset {
        return Ruleset(
            speedIncreaseMultiplier: 1.1,
            speedDecreaseMultiplier: 0.8)
    }
}

// @RENAME: 'updater'?
protocol RulesetModifier {
    func updateRuleset(ruleset: Ruleset, config: GameConfig, events: [Event]) -> GameConfig
}

class DefaultRulesetModifier: RulesetModifier {
    func updateRuleset(ruleset: Ruleset, config: GameConfig, events: [Event]) -> GameConfig {
        var updatedConfig = config.clone()
        
        for event in events {
            switch (event) {
            case .barrierPass(_):
                updatedConfig.boardScrollSpeed *= ruleset.speedIncreaseMultiplier
            case .barrierHit(_):
                updatedConfig.boardScrollSpeed *= ruleset.speedDecreaseMultiplier
            default: break
            }
        }
        
        return updatedConfig
    }
}
