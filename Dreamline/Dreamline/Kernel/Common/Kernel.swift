//
//  Kernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class MasterKernel: Kernel {
    
    private var state: KernelState
    private var rules: [Rule]
    private var mutators: [Mutator]
    
    private var externalEvents: [KernelEvent]
    private var internalEvents: [KernelEvent]
    
    init(state: KernelState, rules: [Rule], mutators: [Mutator]) {
        self.state = state
        self.rules = rules
        self.mutators = mutators
        
        self.externalEvents = [KernelEvent]()
        self.internalEvents = [KernelEvent]()
    }
    
    func getState() -> KernelState {
        return self.state
    }
    
    func addEvent(event: KernelEvent) {
        self.externalEvents.append(event)
    }
    
    func update(deltaTime: Double) -> [KernelEvent] {
        self.processRules(deltaTime: deltaTime)
        self.compositeEvents()
        self.mutateState()
        return self.internalEvents
    }
    
    private func compositeEvents() {
        self.internalEvents.append(contentsOf: self.externalEvents)
        self.externalEvents.removeAll(keepingCapacity: true)
    }
    
    private func processRules(deltaTime: Double) {
        self.internalEvents.removeAll(keepingCapacity: true)
        for rule in self.rules {
            let event = rule.process(state: self.state, deltaTime: deltaTime)
            // This is tragic
            if event != nil {
                switch event! {
                case .multiple(let events): self.internalEvents.append(contentsOf: events)
                default: self.internalEvents.append(event!)
                }
            }
        }
    }
    
    private func mutateState() {
        for mutator in self.mutators {
            for event in self.internalEvents {
                mutator.mutateState(state: &self.state, event: event)
            }
        }
    }
}

class KernelMasterFactory {
    func make() -> Kernel {
        return MasterKernel(state: self.createState(),
                            rules: self.createRules(),
                            mutators: self.createMutators())
    }
    
    private func createState() -> KernelState {
        return KernelState.master()
    }
    
    private func createRules() -> [Rule] {
        return [TimeRule(),
                ScrollRule(),
                SpawnRule(),
                DespawnRule(),
                PositionRule(),
                CollisionRule(),
                HealthRule(),
                SetupRule()]
    }
    
    private func createMutators() -> [Mutator] {
        return [TimeMutator(),
                BoardMutator(),
                PositionMutator(),
                HealthMutator(),
                ChunkMutator(),
                FlowControlMutator()]
    }
}
