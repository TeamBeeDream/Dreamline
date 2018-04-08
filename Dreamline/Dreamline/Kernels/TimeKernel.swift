//
//  TimeKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class TimeKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> TimeKernel {
        let instance = TimeKernel()
        return instance
    }
    
    // MARK: Kernel Methods
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        
        switch instr {
            
        case .tick(let deltaTime):
            state.timeState.frameNumber += 1
            state.timeState.deltaTime = deltaTime
            state.timeState.timeSinceBeginning += deltaTime
            events.append(.tick(deltaTime))
            
        case .pause:
            state.timeState.paused = true
            events.append(.paused)
            
        case .unpause:
            state.timeState.paused = false
            events.append(.unpaused)
            
        default: break
            
        }
    }
}
