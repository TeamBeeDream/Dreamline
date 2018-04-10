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
    
    private var stateBuffer = ToggleBuffer.make(value: KernelState.new())
    private var eventBuffer = ToggleBuffer.make(value: [KernelEvent]())
    private var instrBuffer = ToggleBuffer.make(value: [KernelInstruction]())
    
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
        let inputInstruction = KernelInstruction.updateInput(self.inputTarget)
        
        var workingEvents = self.eventBuffer.access()   // @CLEANUP
        var workingState = self.stateBuffer.access()    // @CLEANUP
        
        var instructions = self.instrBuffer.access()
        instructions.append(inputInstruction)
        
        // @HACK
        // @FIXME: Ensure that remove instructions are handled correctly
        // They should probably be done at the very end of the frame
        // to prevent data issues in the rules/observers
        let instrNoRemoves = instructions.filter {  !self.noRemove($0) }
        let instrJustRemoves = instructions.filter { self.noRemove($0) }
        
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
        
        // RULES
        self.instrBuffer.toggle()
        var newInstructions = self.instrBuffer.access()
        newInstructions.removeAll(keepingCapacity: true) // ?
        for rule in self.rules {
            rule.mutate(events: &workingEvents,
                        instructions: &newInstructions,
                        deltaTime: deltaTime)
        }
        
        // OBSERVERS
        for observer in self.observers {
            observer.observe(events: workingEvents)
        }
        
        // @ROBUST: Check memory usage around toggle buffers
        
        self.stateBuffer.toggle()
        self.stateBuffer.inject(workingState)
        
        workingEvents.removeAll() // ?
        self.eventBuffer.toggle()
        
        self.instrBuffer.toggle()
        self.instrBuffer.inject(newInstructions)
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
        self.stateBuffer.inject(state)
        for rule in self.rules { rule.setup(state: state) }
        for observer in self.observers { observer.setup(state: state) }
    }
    
    // @ROBUSTNESS
    private func noRemove(_ instr: KernelInstruction)  -> Bool {
        switch instr {
        case .removeEntity: return false
        default:            return true
        }
    }
}
