//
//  ChunkSequencer.swift
//  Dreamline
//
//  Created by BeeDream on 4/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol ChunkSequencer {
    func getChunks(level: Int) -> [Chunk]
}

class DebugChunkSequencer: ChunkSequencer {
    func getChunks(level: Int) -> [Chunk] {
        switch level {
        default: return self.getChunks(start: 0.2, end: 1.0, variation: 0.1, count: 1)
        }
    }
    
    private func getChunks(start: Double, end: Double, variation: Double, count: Int) -> [Chunk] {
        var chunks = [Chunk]()
        for i in 1...count {
            let t = clamp(Double(i) / Double(count), min: 0.1, max: 1.0)
            let difficulty = self.calculate(start: start, end: end,
                                            t: t, variation: variation)
            let chunkState = Chunk(type: .barriers, difficuly: difficulty, length: 10)
            chunks.append(chunkState)
        }
        chunks.append(Chunk(type: .finish, difficuly: 0.0, length: 10))
        return chunks
    }
    
    private func calculate(start: Double, end: Double,
                        t: Double, variation: Double) -> Double {
        let difficulty = lerp(t, min: start, max: end)
        let randomVariation = self.getRandomVariation(variation: variation)
        return clamp(difficulty * randomVariation, min: 0.1, max: 1.0)
    }
    
    private func getRandomVariation(variation: Double) -> Double {
        let randomValue = RealRandom().next()
        let negativeOrPositive = Double(RealRandom().nextBool() ? -1 : 1)
        return randomValue * variation * negativeOrPositive
    }
}

class MasterChunkSequencer: ChunkSequencer {
    func getChunks(level: Int) -> [Chunk] {
        var lookupTable = [Int: (difficulty: [Double], length: [Int])]()
        lookupTable[1] = (difficulty:   [0.6],
                          length:       [  5])
        lookupTable[2] = (difficulty:   [0.6, 0.7],
                          length:       [  5,   5])
        lookupTable[3] = (difficulty:   [0.7, 0.8],
                          length:       [  5,   8])
        lookupTable[4] = (difficulty:   [0.7, 0.8, 0.9],
                          length:       [  5,   5,   5])
        lookupTable[5] = (difficulty:   [0.8, 0.9, 1.0],
                          length:       [  8,   8,   5])
        
        // @HACK
        let levelIndex = clamp(level, min: 1, max: lookupTable.count-1)
        let data = lookupTable[levelIndex]!
        return self.generateChunks(count: data.difficulty.count,
                                   difficulty: data.difficulty,
                                   length: data.length)
    }
    
    private func generateChunks(count: Int, difficulty: [Double], length: [Int]) -> [Chunk] {
        var chunks = [Chunk]()
        for i in 0...count-1 {
            let chunk = Chunk(type: .barriers, difficuly: difficulty[i], length: length[i])
            chunks.append(chunk)
        }
        chunks.append(Chunk(type: .finish, difficuly: 0.0, length: 3))
        return chunks
    }
}
