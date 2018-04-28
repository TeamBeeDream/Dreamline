//
//  Kernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class KernelImpl: Kernel {
    
    private var state: KernelState
    private var rules: [Rule]
    private var mutators: [Mutator]
    
    private var externalEvents = [KernelEvent]()
    
    init(state: KernelState, rules: [Rule], mutators: [Mutator]) {
        self.state = state
        self.rules = rules
        self.mutators = mutators
    }
    
    func getState() -> KernelState {
        return self.state
    }
    
    func addEvent(event: KernelEvent) {
        self.externalEvents.append(event)
    }
    
    func update(deltaTime: Double) -> [KernelEvent] {
        let events = self.processRules(deltaTime: deltaTime)
        self.mutateState(events: events)
        self.mutateState(events: self.externalEvents)
        self.clearExternalEvents()
        return events
    }
    
    private func processRules(deltaTime: Double) -> [KernelEvent] {
        var events = [KernelEvent]()
        for rule in self.rules {
            let event = rule.process(state: self.state, deltaTime: deltaTime)
            if event != nil { events.append(event!) }
        }
        return events
    }
    
    private func mutateState(events: [KernelEvent]) {
        for mutator in self.mutators {
            for event in events {
                mutator.mutateState(state: &self.state, event: event)
            }
        }
    }
    
    private func clearExternalEvents() {
        self.externalEvents.removeAll()
    }
}

class KernelMasterFactory {
    func make() -> Kernel {
        return KernelImpl(state: self.getState(),
                          rules: self.getRules(),
                          mutators: self.getMutators())
    }
    
    private func getState() -> KernelState {
        return KernelState.master()
    }
    
    private func getRules() -> [Rule] {
        return [TimeRule(),
                ScrollRule(),
                SpawnRule(),
                PositionRule()]
    }
    
    private func getMutators() -> [Mutator] {
        return [TimeMutator(),
                BoardMutator(),
                PositionMutator()]
    }
}
