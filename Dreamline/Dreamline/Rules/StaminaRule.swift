//
//  StaminaRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class StaminaRule: Rule {
    
    // MARK: Init
    
    static func make() -> StaminaRule {
        return StaminaRule()
    }
    
    // MARK: Rule Methods
    
    func mutate(state: KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        // Respond to events
        for event in events {
            switch event {

            case .entityStateChanged(let entity):
                switch entity.type {
                case .barrier:
                    if entity.state == .hit    { instructions.append(.decrementStamina) }
                    if entity.state == .passed { instructions.append(.incrementStamina) }
                    
                default: break
                }
                
            case .staminaUpdated(let level):
                if level < 0 { // && !state.dead
                    // @TODO: Trigger death instruction
                }
                
            default:
                break
                
            }
        }
    }
}
