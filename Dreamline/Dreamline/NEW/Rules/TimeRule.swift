//
//  TimeProtocol.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class TimeRule: Rule {
    
    // MARK: Init
    
    static func make() -> TimeRule {
        return TimeRule()
    }
    
    // MARK: Rule Methods
    
    /*func process(state: KernelState,
                 events: [KernelEvent],
                 deltaTime: Double) -> ([RuleFlag], [KernelInstruction]) {
        
        var instructions = [KernelInstruction]()
        
        if !state.timeState.paused {
            instructions.append(.tick(deltaTime))
        }
        
        return ([RuleFlag](), instructions)
    }*/
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
    
        if !state.timeState.paused {
            instructions.append(.tick(deltaTime))
        }
    }
}
