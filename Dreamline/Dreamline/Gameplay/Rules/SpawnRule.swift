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
    private var completedChunks: Int = 0
    
    private var layout: BoardLayout!
    private var distanceBetweenEntities: Double!
    
    private var sequencer: EntitySequencer!
    private var entityBuffer: [(EntityType, EntityData)]!
    private var didCompleteLastChunk: Bool = true // @HACK
    private var adding: Bool = true
    
    // MARK: Init
    
    static func make(sequencer: EntitySequencer) -> Rule {
        let instance = SpawnRule()
        instance.sequencer = sequencer
        instance.entityBuffer = [(EntityType, EntityData)]()
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
                // :(
                if phase == .setup {
                    self.setupSequencer()
//                    let speed = 1.4
//                    let distance = self.calculateDistanceBetweenBarriers(timeToCompleteInSeconds: 45,
//                                                                         speed: speed)
//                    instructions.append(.configureBoard(speed, distance))
                }
                if phase == .results {
                    self.adding = false
                }
                
            case .entityStateChanged(let entity):
                if entity.isA(.threshold) {
                    if entity.state != .hit { break }
                    if entity.thresholdType() == .chunkEnd {
                        self.completedChunks += 1
                        self.didCompleteLastChunk = true
                    }
                }
                
                if entity.isA(.barrier) {
                    if entity.state == .hit {
                        self.didCompleteLastChunk = false
                        
                    }
                }
                
            case .boardScrolled(let position, _):
                if !self.shouldPlaceEntity(boardPosition: position) { break }
                
                let entityPosition = self.calculateNearestEntityPosition(boardPosition: position)
                self.lastBarrierPosition = entityPosition
                
                let data = self.getNextEntity()
                let entity = Entity(id: self.currentId,
                                    position: self.layout.lowerBound,
                                    state: .none,
                                    type: data.0,
                                    data: data.1)
                self.currentId += 1
                instructions.append(.addEntity(entity))
                
            default: break
                
            }
        }
    }
    
    private func shouldPlaceEntity(boardPosition: Double) -> Bool {
        let nearestPosition = self.calculateNearestEntityPosition(boardPosition: boardPosition)
        return self.adding && nearestPosition > self.lastBarrierPosition
    }
    
    private func calculateNearestEntityPosition(boardPosition: Double) -> Double {
        let overshoot = boardPosition.truncatingRemainder(dividingBy: self.distanceBetweenEntities)
        return boardPosition - overshoot
    }
    
    private func getNextEntity() -> (EntityType, EntityData) {
        if self.entityBuffer.isEmpty {
            self.entityBuffer = self.sequencer.getNextChunk(didCompleteLastChunk: self.didCompleteLastChunk)
            self.didCompleteLastChunk = false
        }
        return self.entityBuffer.removeFirst()
    }
    
    func setupSequencer() {
        let sequencer: [ChunkType] = [
            .empty(length: 5),
            .normal(length: 10, difficulty: 0.2, trailing: 5),
            .normal(length: 10, difficulty: 0.3, trailing: 5),
            .normal(length: 10, difficulty: 0.5, trailing: 5),
            .finish(trailing: 10)]
        self.sequencer.setSequence(sequencer)
        self.didCompleteLastChunk = true // @HACK
        self.entityBuffer.removeAll() // @HACK
        self.lastBarrierPosition = 0
        self.adding = true
    }
}
