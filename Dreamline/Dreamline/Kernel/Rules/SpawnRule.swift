//
//  SpawnRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SpawnRule: Rule {
    
    private var regulator = SpawnRegulator()
    private var sequencer = SpawnSequencer()
    private var lastId: Int = 0 // @HACK
    
    func process(state: KernelState, deltaTime: Double) -> KernelEvent? {
        if state.flowControl.phase == .origin {
            self.sequencer.clear()
        }
        if state.flowControl.phase != .play { return nil }
        
        if !self.regulator.shouldSpawnEntity(boardPosition: state.board.position,
                                             distanceBetweenBarriers: state.board.distanceBetweenEntities,
                                             lastEntityPosition: state.board.lastEntityPosition) {
            return nil
        }
        
        return .boardEntityAdd(entity: self.getNextEntity(state: state))
    }
    
    // @CLEANUP
    private func getNextEntity(state: KernelState) -> Entity {
        guard let chunk = state.chunk.current else {
            let entity = Entity(id: self.lastId,
                                position: state.board.layout.lowerBound,
                                type: .blank,
                                state: .none)
            self.lastId += 1
            return entity
        }
        
        let type = self.sequencer.getNextEntity(type: chunk.type,
                                                difficulty: chunk.difficuly,
                                                length: chunk.length)
        let entity = Entity(id: self.lastId,
                            position: state.board.layout.lowerBound,
                            type: type,
                            state: .none)
        self.lastId += 1
        
        return entity
    }
}

class SpawnRegulator {
    func shouldSpawnEntity(boardPosition: Double,
                           distanceBetweenBarriers: Double,
                           lastEntityPosition: Double) -> Bool {
        return boardPosition > self.getSpawnPosition(distanceBetweenBarriers: distanceBetweenBarriers,
                                                     lastEntityPosition: lastEntityPosition)
    }
    
    func getSpawnPosition(distanceBetweenBarriers: Double,
                          lastEntityPosition: Double) -> Double {
        return lastEntityPosition + distanceBetweenBarriers
    }
}

// @TODO: Unit tests
class SpawnSequencer {
    
    private var buffer = [EntityType]()
    private var generator = EntityGenerator(random: RealRandom())
    
    private let trailing = 5 // @HARDCODED
    
    func getNextEntity(type: ChunkType, difficulty: Double, length: Int) -> EntityType {
        if self.buffer.isEmpty {
            self.generateNextChunk(type: type, difficulty: difficulty, length: length)
        }
        return self.buffer.removeFirst()
    }
    
    func clear() {
        self.buffer.removeAll()
    }
    
    private func generateNextChunk(type: ChunkType, difficulty: Double, length: Int) {
        switch type {
        case .empty:
            self.generateEmptyChunk(length: length)
        case .barriers:
            self.generateBarrierChunk(difficulty: difficulty, length: length)
        case .finish:
            self.generateFinishChunk(length: length)
        }
    }
    
    private func generateEmptyChunk(length: Int) {
        for _ in 1...length {
            self.buffer.append(self.generator.generateEmpty())
        }
    }
    
    private func generateBarrierChunk(difficulty: Double, length: Int) {
        for _ in 1...length-1 {
            self.buffer.append(self.generator.generateBarrier())
        }
        self.buffer.append(self.generator.generateChunkEndThreshold())
        for _ in 1...self.trailing {
            self.buffer.append(self.generator.generateEmpty())
        }
    }
    
    private func generateFinishChunk(length: Int) {
        self.buffer.append(self.generator.generateRoundEndThreshold())
        for _ in 1...length {
            self.buffer.append(self.generator.generateEmpty())
        }
    }
}

class EntityGenerator {
    
    private var random: Random
    
    init(random: Random) {
        self.random = random
    }
    
    func generateEmpty() -> EntityType {
        return .blank
    }
    
    func generateRoundEndThreshold() -> EntityType {
        return .threshold(type: .roundEnd)
    }
    
    func generateChunkEndThreshold() -> EntityType {
        return .threshold(type: .chunkEnd)
    }
    
    func generateBarrier() -> EntityType {
        let numberOfOpenGates = self.random.nextBool() ? 1 : 2
        let gates = self.generateRandomGateArray(numberOfOpenGates: numberOfOpenGates)
        return .barrier(gates: gates)
    }
    
    private func generateRandomGateArray(numberOfOpenGates: Int) -> [Gate] {
        var gates: [Gate] = [.closed, .closed, .closed]
        for _ in 1...numberOfOpenGates {
            let randomLane = self.random.nextInt(min: 0, max: 3)
            gates[randomLane] = .open
        }
        return gates
    }
}
