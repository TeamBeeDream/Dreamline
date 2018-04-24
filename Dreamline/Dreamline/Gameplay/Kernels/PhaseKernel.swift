//
//  GameKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/24/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @NOTE: Need a better solution for handling state changes in the game.
class PhaseKernel: Kernel {
    
    static func make() -> PhaseKernel {
        return PhaseKernel()
    }
    
    func update(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        switch instr {
            
        case .updatePhase(let phase):
            state.phaseState = phase
            events.append(.phaseChanged(state.phaseState))
            
        case .roundComplete:
            events.append(.roundComplete(state.scoreState))
            
        default: break
        }
    }
}
