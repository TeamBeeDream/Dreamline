//
//  Focus.swift
//  Dreamline
//
//  Created by BeeDream on 4/3/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Focus {
    // @NOTE: Should probably minimize the connection to GameConfig
    // and just pass in the necessary values
    func update(state: FocusState,
                dt: Double,
                events: [Event],
                config: GameConfig) -> (FocusState, [Event])
}

// @RENAME
class DefaultFocus: Focus {
    
    // MARK: Init
    
    static func make() -> Focus {
        return DefaultFocus()
    }
    
    // MARK: Focus Methods
    
    func update(state: FocusState,
                dt: Double,
                events: [Event],
                config: GameConfig) -> (FocusState, [Event]) {
        
        var updatedState = state.clone()
        var raisedEvents = [Event]()
        
        // Update delay
        let newDelay = state.delay - dt
        if newDelay < 0.0 {
            raisedEvents.append(.focusGain)
            updatedState.level = min(state.level + 1, config.focusMaxLevel)
            updatedState.delay = config.focusDelay
        } else {
            updatedState.delay = newDelay
        }
        
        // @CLEANUP: Move these pieces to separate functions
        for event in events {
            switch event {
                
            // @NOTE: When you hit a barrier, lower the focus level by 1
            // If out of levels, raise .focusGone event
            case .barrierHit(_):
                let level = state.level - 1
                raisedEvents.append(.focusLoss)
                if level <= 0 { raisedEvents.append(.focusGone) }
                updatedState.level = max(0, level)
                updatedState.delay = config.focusDelay
                
            default:
                break
                
            }
            
        }
        
        return (updatedState, raisedEvents)
    }
}
