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
    
    private var currentId: Int = 0
    private var lastBarrierPosition: Double = 0.0
    private var sequencer: Sequencer!
    
    // MARK: Init
    
    static func make(distanceBetweenEntities: Double) -> Rule {
        let instance = SpawnRule()
        instance.distanceBetweenEntities = distanceBetweenEntities
        instance.sequencer = TempSequencer.make(random: RealRandom()) // @HARDCODED
        return instance
    }
    
    // MARK: Rule Methods
    
    func mutate(state: KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        let currentDistance = state.boardState.scrollDistance
        let overshoot = currentDistance.truncatingRemainder(dividingBy: self.distanceBetweenEntities)
        let nearest = currentDistance - overshoot
        
        // @CLEANUP
        if nearest > self.lastBarrierPosition {
            let next = self.sequencer.nextEntity()
            for type in next {
                let entity = EntityData(id: self.currentId, // <-- This is super dangerous @ROBUSTNESS
                                        position: state.boardState.layout.lowerBound,
                                        state: .none,
                                        type: type)
                instructions.append(.addEntity(entity))
                self.currentId += 1
            }
            self.lastBarrierPosition = nearest
        }
    }
}
