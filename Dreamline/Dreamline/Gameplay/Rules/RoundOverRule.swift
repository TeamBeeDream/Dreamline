//
//  TempRoundOverThresholdRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/19/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class RoundOverRule: Rule {
    
    // MARK: Init
    
    static func make() -> RoundOverRule {
        return RoundOverRule()
    }
    
    // MARK: Rule Methods
    
    func sync(state: KernelState) {}
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
            case .entityStateChanged(let entity):
                if !entity.isA(.threshold) { break }
                if entity.thresholdType()! != .roundEnd { break }
                
                instructions.append(.updatePhase(.results))
                instructions.append(.roundComplete)
                
            default: break
            }
        }
    }
}
