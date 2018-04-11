//
//  SpeedRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SpeedRule: Rule {
    
    // MARK: Private Properties
    
    private var speed: Double!
    private var currentLane: Int!
    
    // MARK: Init
    
    static func make() -> SpeedRule {
        let instance = SpeedRule()
        return instance
    }
    
    // MARK: Rule Methods
    
    func setup(state: KernelState) {
        self.speed = state.speedState.speed
        self.currentLane = state.positionState.nearestLane
    }
    
    func mutate(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
                
            case .speedUpdated(let speed):
                self.speed = speed
                
            // @NOTE: This is a little unfortunate, should there be more specific
            // events produced by the kernel?  I.e. .thresholdCrossed(type)
            // Would probably need some translation layer between kernel and rules :(
            case .entityStateChanged(let entity):
                if entity.isThreshold() && entity.thresholdType() == .speed {
//                    let maxSpeed = 2.0 // @HARDCODED
//                    let newSpeed = min(maxSpeed, self.speed + 0.2)
//                    instructions.append(.updateSpeed(newSpeed)) // @TEMP @HARDCODED
                }
                
            // Slow down speed when moving laterally
//            case .positionUpdated(let position):
//                if position.nearestLane == self.currentLane { break }
//
//                self.currentLane = position.nearestLane
//                instructions.append(.updateSpeed(self.speed - 0.05)) // @TEMP @HARDCODED
                
            case .staminaUpdated(let stamina):
                if stamina % 5 == 0 && stamina > 0 {
                    let newSpeed = self.speed + 0.2 // @HARDCODED
                    instructions.append(.updateSpeed(newSpeed))
                }
                
            default: break
            }
        }
    }
}
