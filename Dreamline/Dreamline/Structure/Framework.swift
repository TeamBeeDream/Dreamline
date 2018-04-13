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
    
    // @NOTE: This is probably not the most
    // efficient way to hold data in memory
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
        
        // INPUT @HACK
        let inputInstruction = KernelInstruction.updateInput(self.inputTarget)
        workingInstructions.append(inputInstruction)
        
        // KERNEL
        for kernel in self.kernels {
            // Handle removes first, if any instructions involve
            // removed entities should just be ignored (rip)
            let instrJustRemoves = workingInstructions.filter { !self.isRemove($0) }
            for instr in instrJustRemoves {
                kernel.update(state: &workingState,
                              events: &workingEvents,
                              instr: instr)
            }
            // Handle the rest of the instructions
            let instrNoRemoves = workingInstructions.filter { self.isRemove($0) }
            for instr in instrNoRemoves {
                kernel.update(state: &workingState,
                              events: &workingEvents,
                              instr: instr)
            }
        }
        workingInstructions.removeAll(keepingCapacity: true) // Clear so rules can use this
        
        // RULES
        for rule in self.rules {
            rule.decide(events: &workingEvents,
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
        for rule in self.rules { rule.sync(state: state) }
        for observer in self.observers { observer.sync(state: state) }
        
        self.state = state
        self.events = [KernelEvent]()
        self.instructions = [KernelInstruction]()
    }
    
    // @ROBUSTNESS
    private func isRemove(_ instr: KernelInstruction)  -> Bool {
        switch instr {
        case .removeEntity: return true
        default:            return false
        }
    }
}
