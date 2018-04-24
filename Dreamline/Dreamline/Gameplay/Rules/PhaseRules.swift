//
//  PhaseRuels.swift
//  Dreamline
//
//  Created by BeeDream on 4/24/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class PhaseRules: Rule {
    
    static func make() -> PhaseRules {
        return PhaseRules()
    }
    
    func sync(state: KernelState) {}
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        for event in events {
            switch event {
            case .phaseChanged(let phase):
                switch phase {
                    
                case .setup:
                    self.setup(instructions: &instructions)
                    
                case .play:
                    break
                    
                case .reset:
                    self.reset(instructions: &instructions)
                    
                case .results:
                    break
                    
                default: break
                }
                
            default: break
            }
        }
    }
    
    private func setup(instructions: inout [KernelInstruction]) {
        // @TODO
        instructions.append(.updatePhase(.play))
    }
    
    private func reset(instructions: inout [KernelInstruction]) {
        instructions.append(.resetBoard)
        instructions.append(.resetTime)
        instructions.append(.resetScore)
        instructions.append(.updatePhase(.setup))
    }
}
