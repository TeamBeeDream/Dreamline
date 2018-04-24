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
    
    private var layout: BoardLayout!
    
    private var entityBuffer: [(EntityType, EntityData)]!
    
    // MARK: Init
    
    static func make() -> Rule {
        let sequencer = TempBarrierSequencer.make()
        let params = SequencerParams(density: 0.5, length: 15) // @HARDCODED
        
        let instance = SpawnRule()
        instance.entityBuffer = sequencer.generateEntities(params: params)
        return instance
    }
    
    // MARK: Rule Methods
    
    func sync(state: KernelState) {
        self.layout = state.boardState.layout
    }
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
                
            case .boardScrolled(let distance, _):
                let overshoot = distance.truncatingRemainder(dividingBy: self.layout.distanceBetweenEntities)
                let nearest = distance - overshoot
                
                // @CLEANUP
                if nearest > self.lastBarrierPosition {
                    if self.entityBuffer.isEmpty { break }
                    let bundle = self.entityBuffer.remove(at: 0)
                    let entity = Entity(id: self.currentId, // <-- This is super dangerous @ROBUSTNESS
                        position: self.layout.lowerBound,
                        state: .none,
                        type: bundle.0,
                        data: bundle.1)
                    instructions.append(.addEntity(entity))
                    self.currentId += 1
                
                    self.lastBarrierPosition = nearest
                }
                
            default: break
                
            }
        }
    }
}
