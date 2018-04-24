//
//  BarrierRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/23/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class BarrierRule: Rule {
    
    static func make() -> BarrierRule {
        let instance = BarrierRule()
        return instance
    }
    
    func sync(state: KernelState) {}
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
            case .entityStateChanged(let entity):
                if !entity.isA(.barrier) { break }
                if entity.state == .passed  { instructions.append(.addScore(1)) }
                if entity.state == .hit     { instructions.append(.decrementStamina) }
                
            default: break
            }
        }
    }
}
