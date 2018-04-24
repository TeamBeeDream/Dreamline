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
    func addInstruction(instruction: KernelInstruction)
}

protocol FrameworkDelegate {
    func tempTransition()
}

protocol InputDelegate {
    func addInput(lane: Int)
    func removeInput(count: Int)
    func triggerTap()
}

class DefaultFramework: Framework, InputDelegate {
    
    // MARK: Public Properties
    
    var delegate: FrameworkDelegate!
    
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
    private var pendingInstructions = [KernelInstruction]()
    
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
        workingInstructions.append(contentsOf: self.pendingInstructions)
        self.pendingInstructions.removeAll()
        
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
    
    func addInstruction(instruction: KernelInstruction) {
        self.pendingInstructions.append(instruction)
    }
    
    // MARK: Input Delegate Methods
    
    func addInput(lane: Int) {
        self.inputCount += 1
        self.updateInput(lane: lane)
    }
    
    func removeInput(count: Int) {
        self.inputCount -= count
        if self.inputCount == 0 {
            self.updateInput(lane: 0) // Reset to center
        }
    }
    
    func triggerTap() {
        self.pendingInstructions.append(.addTap)
    }
    
    private func updateInput(lane: Int) {
        self.inputTarget = lane
        self.pendingInstructions.append(.updateInput(lane))
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
