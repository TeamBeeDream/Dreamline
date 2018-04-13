//
//  TimeProtocol.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class TimeRule: Rule {
    
    // MARK: Private Properties
    
    private var paused: Bool!
    
    // MARK: Init
    
    static func make() -> TimeRule {
        return TimeRule()
    }
    
    // MARK: Rule Methods
    
    func sync(state: KernelState) {
        self.paused = state.timeState.paused
    }
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
    
        for event in events {
            switch event {
            case .paused: self.paused = true
            case .unpaused: self.paused = false
            default: break
            }
        }
        
        if !self.paused { instructions.append(.tick(deltaTime)) }
    }
}
