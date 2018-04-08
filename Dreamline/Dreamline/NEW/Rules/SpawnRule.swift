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
    
    func process(state: KernelState,
                 events: [KernelEvent],
                 deltaTime: Double) -> ([RuleFlag], [KernelInstruction]) {
        
        // Raise instructions
        var instructions = [KernelInstruction]()
        
        let currentDistance = state.boardState.scrollDistance
        let mod = currentDistance.truncatingRemainder(dividingBy: self.distanceBetweenEntities)
        let nearest = currentDistance - mod
        
        if nearest > self.lastBarrierPosition {
            let entity = EntityData(id: self.currentId,
                                    position: state.boardState.layout.lowerBound,
                                    type: .barrier([true, true, true]))
            instructions.append(.addEntity(entity))
            
            self.lastBarrierPosition = nearest
            self.currentId += 1
        }
        
        return ([RuleFlag](), instructions)
    }
}
