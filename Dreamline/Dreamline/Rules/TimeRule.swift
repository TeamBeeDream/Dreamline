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
    
    func mutate(state: KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
    
        // @FIXME
        if !state.timeState.paused {
            instructions.append(.tick(deltaTime))
        }
    }
}
