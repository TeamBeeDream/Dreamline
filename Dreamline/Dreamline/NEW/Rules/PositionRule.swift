//
//  PositionRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class PositionRule: Rule {
    
    // MARK: Init
    
    static func make() -> PositionRule {
        return PositionRule()
    }
    
    // MARK: Rule Methods
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        let target = Double(state.inputState.targetLane)
        let moveDuration = 0.1  // @HARDCODED
        
        let diff = target - state.positionState.offset
        let step = clamp(state.timeState.deltaTime / moveDuration,
                         min: 0.0, max: 1.0)
        
        let delta = step * diff
        instructions.append(.updatePositionOffset(state.positionState.offset + delta))
    }
}
