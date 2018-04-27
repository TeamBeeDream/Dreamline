//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol EntitySequencer {
    func setSequence(_ sequence: [ChunkType])
    func getNextChunk(didCompleteLastChunk: Bool) -> [(EntityType, EntityData)]
}

enum ChunkType {
    case empty(length: Int)
    case normal(length: Int, difficulty: Double, trailing: Int)
    case finish(trailing: Int)
}

class SequencerImpl: EntitySequencer {
    
    private var generator: EntityGenerator
    private var sequence: [ChunkType]!
    
    init(generator: EntityGenerator) {
        self.generator = generator
    }
    
    func setSequence(_ sequence: [ChunkType]) {
        self.sequence = sequence
    }
    
    func getNextChunk(didCompleteLastChunk: Bool) -> [(EntityType, EntityData)] {
        let type = self.getNextChunkType(didCompleteLastChunk: didCompleteLastChunk)
        return self.generator.generateChunk(type: type)
    }
    
    private func getNextChunkType(didCompleteLastChunk: Bool) -> ChunkType {
        if didCompleteLastChunk {
            return self.sequence.removeFirst()
        } else {
            return self.sequence.first!
        }
    }
}

protocol EntityGenerator {
    func generateChunk(type: ChunkType) -> [(EntityType, EntityData)]
}

class DefaultEntityGenerator: EntityGenerator {
    
    func generateChunk(type: ChunkType) -> [(EntityType, EntityData)] {
        switch type {
        case .empty(let length):
            return self.generateEmptyChunk(length: length)
        case .normal(let length, let difficulty, let trailing):
            return self.generateNormalChunk(length: length,
                                            difficulty: difficulty,
                                            trailing: trailing)
        case .finish(let trailing):
            return self.generateFinishChunk(trailing: trailing)
        }
    }
    
    private func generateEmptyChunk(length: Int) -> [(EntityType, EntityData)] {
        var entities = [(EntityType, EntityData)]()
        for _ in 1...length {
            entities.append(self.generateBlankEntity())
        }
        return entities
    }
    
    private func generateNormalChunk(length: Int,
                                     difficulty: Double,
                                     trailing: Int) -> [(EntityType, EntityData)] {
        var entities = [(EntityType, EntityData)]()
        entities.append(contentsOf: self.generateRandomBarriers(count: length-1, difficulty: difficulty))
        entities.append(self.generateChunkEndThresholdEntity())
        entities.append(contentsOf: self.generateEmptyChunk(length: trailing))
        return entities
    }
    
    private func generateFinishChunk(trailing: Int) -> [(EntityType, EntityData)] {
        var entities = [(EntityType, EntityData)]()
        entities.append(self.generateRoundEndThresholdEntity())
        entities.append(contentsOf: self.generateEmptyChunk(length: trailing))
        return entities
    }
    
    private func generateRandomBarriers(count: Int, difficulty: Double) -> [(EntityType, EntityData)] {
        var barriers = [(EntityType, EntityData)]()
        for _ in 1...count {
            // @TODO: Account for difficulty
            barriers.append(self.generateRandomBarrierEntity())
        }
        return barriers
    }
    
    func generateBlankEntity() -> (EntityType, EntityData) {
        return (.blank, .blank)
    }
    
    func generateRoundEndThresholdEntity() -> (EntityType, EntityData) {
        return (.threshold, .threshold(.roundEnd))
    }
    
    func generateChunkEndThresholdEntity() -> (EntityType, EntityData) {
        return (.threshold, .threshold(.chunkEnd))
    }
    
    func generateRandomBarrierEntity() -> (EntityType, EntityData) {
        let numberOfOpenGates = RealRandom().nextBool() ? 1 : 2 // gross
        let gates = self.generateRandomGateArray(numberOfOpenGates: numberOfOpenGates)
        return (.barrier, .barrier(gates))
    }
    
    private func generateRandomGateArray(numberOfOpenGates: Int) -> [Gate] {
        var gates: [Gate] = [.closed, .closed, .closed]
        for _ in 1...numberOfOpenGates {
            let randomLane = RealRandom().nextInt(min: 0, max: 3)
            gates[randomLane] = .open
        }
        return gates
    }
}
