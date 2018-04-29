//
//  ChunkSequencer.swift
//  Dreamline
//
//  Created by BeeDream on 4/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class ChunkSequencer {
    func getChunks(start: Double, end: Double, variation: Double, count: Int) -> [Chunk] {
        
        var chunks = [Chunk]()
        //chunks.append(Chunk(type: .empty, difficuly: 0.0, length: 5))
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
