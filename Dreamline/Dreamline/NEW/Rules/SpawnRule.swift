//
//  SpawnRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SpawnRule: Rule {
    
    // MARK: Public Properties
    
    var distanceBetweenEntities: Double = 0
    
    // MARK: Private Properties
    
    var currentId: Int = 0
    var lastBarrierPosition: Double = 0.0
    
    // MARK: Init
    
    static func make(distanceBetweenEntities: Double) -> Rule {
        let instance = SpawnRule()
        instance.distanceBetweenEntities = distanceBetweenEntities
        return instance
    }
    
    // MARK: Rule Methods
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        let currentDistance = state.boardState.scrollDistance
        let overshoot = currentDistance.truncatingRemainder(dividingBy: self.distanceBetweenEntities)
        let nearest = currentDistance - overshoot
        
        if nearest > self.lastBarrierPosition {
            let entity = EntityData(id: self.currentId, // <-- This is super dangerous @TODO
                                    position: state.boardState.layout.lowerBound,
                                    type: .barrier([true, true, true]))
            instructions.append(.addEntity(entity))
            
            self.lastBarrierPosition = nearest
            self.currentId += 1
        }
    }
}
