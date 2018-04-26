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
    private var distanceBetweenEntities: Double!
    
    private var entityBuffer: [(EntityType, EntityData)]!
    
    // MARK: Init
    
    static func make() -> Rule {
        let instance = SpawnRule()
        instance.entityBuffer = []
        return instance
    }
    
    // MARK: Rule Methods
    
    func sync(state: KernelState) {
        self.layout = state.boardState.layout
        self.distanceBetweenEntities = state.boardState.distanceBetweenEntities
    }
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
                
            case .boardDistanceChanged(let distanceBetweenBarriers):
                self.distanceBetweenEntities = distanceBetweenBarriers
                
            case .phaseChanged(let phase):
                if phase == .setup {
                    self.generateLevel()
                    let speed = 3.0
                    let distance = self.calculateDistanceBetweenBarriers(timeToCompleteInSeconds: 45,
                                                                         speed: speed)
                    instructions.append(.configureBoard(speed, distance))
                }
                
            case .boardScrolled(let distance, _):
                let overshoot = distance.truncatingRemainder(dividingBy: self.distanceBetweenEntities)
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
    
    func generateLevel() {
        let sequencer = TempBarrierSequencer.make()
        self.entityBuffer = sequencer.generateEntities(numberOfBarriers: 100, density: 1.0)
        
        // @HACK
        self.lastBarrierPosition = 0.0
        self.currentId = 0
    }
    
    func calculateDistanceBetweenBarriers(timeToCompleteInSeconds: Int, speed: Double) -> Double {
        let totalEntityCount = Double(self.entityBuffer.count)
        return ((Double(timeToCompleteInSeconds) * speed) / totalEntityCount)
    }
}
