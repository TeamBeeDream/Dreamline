//
//  Configurator.swift
//  Dreamline
//
//  Created by BeeDream on 3/15/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Configurator {
    func updateConfig(config: GameConfig, events: [Event]) -> GameConfig
}


class DefaultConfigurator: Configurator {
    func updateConfig(config: GameConfig, events: [Event]) -> GameConfig {
        var updatedConfig = config.clone()
        for event in events {
            switch (event) {
            case .modifierGet(_, let type):
                updatedConfig.boardScrollSpeed = newSpeed(current: config.boardScrollSpeed, modifier: type)
            default:
                break
            }
        }
        return updatedConfig
    }
    
    private func newSpeed(current: ScrollSpeed, modifier: ModifierType) -> ScrollSpeed {
        // @TODO: Maybe this data should be stored in the ruleset instead of fixed
        //        on the data struct itself?
        let dataTable = ScrollSpeedData.getData() // @CLEANUP: This is silly
        let index = dataTable[current]!.index
        
        switch modifier {
        case .none: return current
        case .speedUp: return ScrollSpeedData.getSpeed(index: index + 1)
        case .speedDown: return ScrollSpeedData.getSpeed(index: index - 1)
        }
    }
}
