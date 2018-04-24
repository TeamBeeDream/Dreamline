//
//  SetupRoundRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/24/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SetupRoundRule: Rule {
    
    static func make() -> SetupRoundRule {
        return SetupRoundRule()
    }
    
    func sync(state: KernelState) {
        
    }
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        for event in events {
            switch event {
            case .phaseChanged(let phase):
                if phase != .reset { break }
                
                instructions.append(.resetTime)
                instructions.append(.clearBoard)
                instructions.append(.updatePositionOffset(0.0))
                instructions.append(.updateInput(0))
                
                instructions.append(.updatePhase(.playing)) // @FIXME: Should go to .intro
                
            default: break
            }
        }
    }
}
