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
    
    init(state: KernelState, rules: [Rule]) {
        self.state = state
        self.rules = rules
    }
    
    func update(deltaTime: Double) -> [KernelEvent] {
        let events = self.processRules(deltaTime: deltaTime)
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
}
