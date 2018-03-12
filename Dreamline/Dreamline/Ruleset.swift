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
            speedIncreaseMultiplier: 1.0,
            speedDecreaseMultiplier: 1.0)
    }
}

// @RENAME: 'updater'?
// also this is a bit misleading, because it is updating the config
// (it is using the fixed ruleset to update the config)
protocol RulesetModifier {
    func updateRuleset(ruleset: Ruleset, config: GameConfig, events: [Event]) -> GameConfig
}

// @NOTE: if we do the ruleset correctly,
// then this class can be strictly data driven
class DefaultRulesetModifier: RulesetModifier {
    func updateRuleset(ruleset: Ruleset, config: GameConfig, events: [Event]) -> GameConfig {
        
        var updatedConfig = config.clone()
        
        for event in events {
            switch (event) {
            case .modifierGet(_, let type):
                updatedConfig.boardScrollSpeed = updateSpeed(
                    current: config.boardScrollSpeed, modifier: type)
            default: break
            }
        }
        
        return updatedConfig
    }
    
    private func updateSpeed(current: ScrollSpeed, modifier: ModifierType) -> ScrollSpeed {
        
        let dataTable = ScrollSpeedData.getData()
        let index = dataTable[current]!.index
        
        switch (modifier) {
        case .none: return current
        case .speedUp: return ScrollSpeedData.getSpeed(index: index + 1)
        case .speedDown: return ScrollSpeedData.getSpeed(index: index - 1)
        }
    }
}
