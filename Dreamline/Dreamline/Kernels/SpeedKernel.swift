//
//  SpeedKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SpeedKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> SpeedKernel {
        let instance = SpeedKernel()
        return instance
    }
    
    // MARK: Kernel Methods
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        
        switch instr {
        
        case .updateSpeed(let speed):
            state.speedState.speed = speed
            events.append(.speedUpdated(speed))
            
        default: break
        }
    }
}
