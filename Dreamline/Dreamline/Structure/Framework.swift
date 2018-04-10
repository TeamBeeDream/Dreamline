//
//  Frame.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Framework {
    func update(deltaTime: Double)
    
    // @TODO
//    func getState() -> KernelState
//    func setState(state: KernelState)
}

protocol InputDelegate {
    func addInput(lane: Int)
    func removeInput(count: Int)
}

class DefaultFramework: Framework, InputDelegate {
    
    // MARK: Framework Properties
    
    private var kernels: [Kernel]!
    private var rules: [Rule]!
    private var observers: [Observer]!
    
    // Buffers
    private var state: KernelState!
    private var instructions: [KernelInstruction]!
    private var events: [KernelEvent]!
    
    // MARK: InputDelegate Properties
    
    private var inputCount: Int = 0
    private var inputTarget: Int = 0
    
    // MARK: Init
    
    static func make(state: KernelState, // @TODO: Pass data store protocol
                     kernels: [Kernel],
                     rules: [Rule],
                     observer: [Observer]) -> DefaultFramework {
        
        let instance = DefaultFramework()
        
        instance.kernels = kernels
        instance.rules = rules
        instance.observers = observer
        instance.syncState(state) // @IMPORTANT
        
        return instance
    }
    
    // MARK: Framework Methods
    
    func update(deltaTime: Double) {
        var workingState = self.state!
        var workingEvents = self.events!
        var workingInstructions = self.instructions!
        
        // @HACK
        let inputInstruction = KernelInstruction.updateInput(self.inputTarget)
        workingInstructions.append(inputInstruction)
        
        // @HACK
        // @FIXME: Ensure that remove instructions are handled correctly
        // They should probably be done at the very end of the frame
        // to prevent data issues in the rules/observers
        let instrNoRemoves = workingInstructions.filter {  !self.noRemove($0) }
        let instrJustRemoves = workingInstructions.filter { self.noRemove($0) }
        
        // KERNEL
        for kernel in self.kernels {
            for instr in instrNoRemoves {
                kernel.mutate(state: &workingState,
                              events: &workingEvents,
                              instr: instr)
            }
            for instr in instrJustRemoves {
                kernel.mutate(state: &workingState,
                              events: &workingEvents,
                              instr: instr)
            }
        }
        workingInstructions.removeAll(keepingCapacity: true) // Clear so rules can use this
        
        // RULES
        for rule in self.rules {
            rule.mutate(events: &workingEvents,
                        instructions: &workingInstructions,
                        deltaTime: deltaTime)
        }
        
        // OBSERVERS
        for observer in self.observers {
            observer.observe(events: workingEvents)
        }
        
        
        // Cleanup for next update
        workingEvents.removeAll(keepingCapacity: true)
        
        self.state = workingState
        self.events = workingEvents
        self.instructions = workingInstructions
    }
    
    // MARK: Input Delegate Methods
    
    func addInput(lane: Int) {
        self.inputTarget = lane
        self.inputCount += 1
    }
    
    func removeInput(count: Int) {
        self.inputCount -= count
        if self.inputCount == 0 {
            self.inputTarget = 0 // Reset to center
        }
    }
    
    // MARK: Private Properties
    
    // @ROBUSTNESS
    private func syncState(_ state: KernelState) {
        //self.stateBuffer.inject(state)
        for rule in self.rules { rule.setup(state: state) }
        for observer in self.observers { observer.setup(state: state) }
        
        self.state = state
        self.events = [KernelEvent]()
        self.instructions = [KernelInstruction]()
    }
    
    // @ROBUSTNESS
    private func noRemove(_ instr: KernelInstruction)  -> Bool {
        switch instr {
        case .removeEntity: return false
        default:            return true
        }
    }
}
