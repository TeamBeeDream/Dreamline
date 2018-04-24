//
//  ResetGameRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/24/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class InputTapRules: Rule {
    
    private var phase: Phase!
    
    static func make() -> InputTapRules {
        return InputTapRules()
    }
    
    func sync(state: KernelState) {
        self.phase = state.phaseState
    }
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        for event in events {
            switch event {
                
            case .phaseChanged(let phase):
                self.phase = phase
                
            case .tapAdded:
                switch self.phase {
                case .results:
                    instructions.append(.updatePhase(.reset))
                    
                default: break
                }
                
            default: break
            }
        }
    }
}
