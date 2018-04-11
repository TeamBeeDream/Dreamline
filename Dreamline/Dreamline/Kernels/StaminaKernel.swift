//
//  StaminaKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class StaminaKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> StaminaKernel {
        return StaminaKernel()
    }
    
    // MARK: Kernel Methods
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        
        switch instr {
            
        case .incrementStamina:
            state.staminaState.level += 1
            events.append(.staminaUpdated(state.staminaState.level))
            
        case .decrementStamina:
            state.staminaState.level -= 1
            events.append(.staminaUpdated(state.staminaState.level))
            
        default:
            break
            
        }
    }
}
