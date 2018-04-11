//
//  SpawnRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SpawnRule: Rule {
    
    // MARK: Private Properties
    
    private var currentId: Int = 0
    private var lastBarrierPosition: Double = 0.0
    
    private var sequencer: Sequencer!
    private var layout: BoardLayout!
    
    // MARK: Init
    
    static func make() -> Rule {
        let instance = SpawnRule()
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
                let overshoot = distance.truncatingRemainder(dividingBy: self.layout.distanceBetweenEntities)
                let nearest = distance - overshoot
                
                // @CLEANUP
                if nearest > self.lastBarrierPosition {
                    let next = self.sequencer.nextEntity()
                    for bundle in next {
                        let entity = Entity(id: self.currentId, // <-- This is super dangerous @ROBUSTNESS
                            position: self.layout.lowerBound,
                            state: .none,
                            type: bundle.0,
                            data: bundle.1)
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
