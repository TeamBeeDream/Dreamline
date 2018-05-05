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

class MasterChunkSequencer: ChunkSequencer {
    func getChunks(level: Int) -> [Chunk] {
        var lookupTable = [Int: (difficulty: [Double], length: [Int], speed: Double)]()
        lookupTable[0] = (difficulty: [], length: [], speed: 1.0) // @HACK @REMOVE
        lookupTable[1] = (difficulty:   [0.8],
                          length:       [  5],
                          speed: 1.0)
        lookupTable[2] = (difficulty:   [0.7, 0.8, 0.9],
                          length:       [  5,   5,   5],
                          speed: 1.15)
        lookupTable[3] = (difficulty:   [0.7, 0.8, 0.8],
                          length:       [  5,   5,   8],
                          speed: 1.25)
        lookupTable[4] = (difficulty:   [0.75, 0.8, 0.9],
                          length:       [   5,   8,   5],
                          speed: 1.35)
        lookupTable[5] = (difficulty:   [0.7, 0.8, 1.0],
                          length:       [  8,   8,  12],
                          speed: 1.4)
        lookupTable[6] = (difficulty:   [0.6, 0.7, 0.8, 0.8],
                          length:       [ 12,  12,  12,  20],
                          speed: 1.5)
        lookupTable[7] = (difficulty:   [0.7, 0.8, 0.9, 0.9, 1.0],
                          length:       [ 12,  12,  15,  15,  25],
                          speed: 1.6)
        lookupTable[8] = (difficulty:   [0.9, 0.9, 1.0, 1.0, 1.0],
                          length:       [  5,   8,  12,  20,  30],
                          speed: 1.7)
        lookupTable[9] = (difficulty:   [1.0],
                          length:       [ 50],
                          speed: 1.8)
        
        // @HACK
        let levelIndex = clamp(level, min: 0, max: lookupTable.count-1)
        let data = lookupTable[levelIndex]!
        return self.generateChunks(count: data.difficulty.count,
                                   difficulty: data.difficulty,
                                   length: data.length,
                                   speed: data.speed)
    }
    
    private func generateChunks(count: Int, difficulty: [Double], length: [Int], speed: Double) -> [Chunk] {
        var chunks = [Chunk]()
        if count != 0 { // @HACK
            for i in 0...count-1 {
                let chunk = Chunk(type: .barriers, difficuly: difficulty[i], length: length[i], speed: speed)
                chunks.append(chunk)
            }
        }
        chunks.append(Chunk(type: .finish, difficuly: 0.0, length: 3, speed: speed))
        return chunks
    }
}
