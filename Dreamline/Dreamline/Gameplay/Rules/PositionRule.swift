//
//  PositionRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class PositionRule: Rule {
    
    // MARK: Private Properties
    
    private var targetLane: Int!
    private var playerOffset: Double!
    private var phase: Phase!
    
    // MARK: Init
    
    static func make() -> PositionRule {
        return PositionRule()
    }
    
    // MARK: Rule Methods
    
    func sync(state: KernelState) {
        self.targetLane = state.inputState.targetLane
        self.playerOffset = state.positionState.offset
        self.phase = state.phaseState
    }
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        // @NOTE: I need to put these events first or else it causes
        // stuttery behavior.  Maybe I should have separate function calls
        // for updating the rule's internal state and one that produces
        // new instructions
        
        for event in events {
            switch event {
                
            case .phaseChanged(let phase):
                self.phase = phase
                
            case .positionUpdated(let position):
                self.playerOffset = position.offset
            
            case .inputChanged(let lane):
                if self.phase == .play {
                    self.targetLane = lane
                }
                
            default: break
                
            }
        }
        
        for event in events {
            switch event {
                
            case .tick(let dt):
                let target = Double(self.targetLane)
                let moveDuration = 0.1  // @HARDCODED
                
                let diff = target - self.playerOffset
                let step = clamp(dt / moveDuration,
                                 min: 0.0, max: 1.0)
                
                let delta = step * diff
                instructions.append(.updatePositionOffset(self.playerOffset + delta))
                
                
            default: break
                
            }
        }
    }
}
