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
    func update(state: FocusState, events: [Event], config: GameConfig) -> (FocusState, [Event])
}

// @RENAME
class DefaultFocus: Focus {
    
    // MARK: Init
    
    static func make() -> Focus {
        return DefaultFocus()
    }
    
    // MARK: Focus Methods
    
    func update(state: FocusState, events: [Event], config: GameConfig) -> (FocusState, [Event]) {
        
        var updatedState = state.clone()
        var raisedEvents = [Event]()
        
        for event in events {
            switch event {
            case .barrierHit(_):
                if state.isMin() { raisedEvents.append(.focusGone) }
                updatedState.current -= 1 // @BUG
                print("focus: \(updatedState.current)")
            default:
                break
            }
        }
        
        return (updatedState, raisedEvents)
    }
}
