//
//  InputKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class InputKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> InputKernel {
        return InputKernel()
    }
    
    // MARK: Kernel Methods
    
    func update(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        
        switch instr {
            
        case .updateInput(let lane):
            state.inputState.targetLane = lane
            events.append(.inputChanged(lane))
            
        case .addTap:
            events.append(.tapAdded)
            
        default: break
            
        }
    }
}
