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
    private var layout: BoardLayout!
    
    // MARK: Init
    
    static func make(distanceBetweenEntities: Double) -> Rule {
        let instance = SpawnRule()
        instance.distanceBetweenEntities = distanceBetweenEntities
        instance.sequencer = TempSequencer.make(random: RealRandom()) // @HARDCODED
        return instance
    }
    
    // MARK: Rule Methods
    
    func setup(state: KernelState) {
        self.layout = state.boardState.layout
    }
    
    func mutate(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
                
            case .boardScrolled(let distance, _):
                let overshoot = distance.truncatingRemainder(dividingBy: self.distanceBetweenEntities)
                let nearest = distance - overshoot
                
                // @CLEANUP
                if nearest > self.lastBarrierPosition {
                    let next = self.sequencer.nextEntity()
                    for type in next {
                        let entity = EntityData(id: self.currentId, // <-- This is super dangerous @ROBUSTNESS
                            position: self.layout.lowerBound,
                            state: .none,
                            type: type)
                        instructions.append(.addEntity(entity))
                        self.currentId += 1
                    }
                    self.lastBarrierPosition = nearest
                }
                
            default: break
                
            }
        }
    }
}
