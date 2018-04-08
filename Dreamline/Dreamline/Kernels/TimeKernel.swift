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
    
    /*func update(state: KernelState,
                instructions: [KernelInstruction]) -> (KernelState, [KernelEvent]) {
        
        // @NOTE: This kernel actually does two things:
        // it does an atomic calculation and it responds
        // to instructions sent from protocols.  It
        // might be possible to separate them into
        // two swappable classes.
       
        var timeState = TimeData.clone(state.timeState)
        var raisedEvents = [KernelEvent]()
        for instr in instructions {
            switch instr {
                
            case .tick(let deltaTime):
                timeState.frameNumber += 1
                timeState.deltaTime = deltaTime
                timeState.timeSinceBeginning += deltaTime
                raisedEvents.append(.tick)
                
            case .pause:
                timeState.paused = true
                raisedEvents.append(.paused)
                
            case .unpause:
                timeState.paused = false
                raisedEvents.append(.unpaused)
                
            default: break
                
            }
        }
        
        // @NOTE: For now this just directly composites the
        // new time state onto a clone of the kernel state.
        // In the furute, this could be done in a different
        // part of the program.
        
        var updatedState = KernelState.clone(state)
        updatedState.timeState = timeState
        
        // @TEMP
        return (updatedState, raisedEvents)
    }*/
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instructions: [KernelInstruction]) {
        
        for instr in instructions {
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
}
