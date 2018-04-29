//
//  ChunkState.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

enum ChunkType {
    case empty
    case barriers
    case finish
}

struct Chunk {
    var type: ChunkType
    var difficuly: Double
    var length: Int
}

struct ChunkState {
    var chunks: [Chunk]
    var current: Chunk?
}

extension ChunkState {
    static func new() -> ChunkState {
        return ChunkState(chunks: [], current: nil)
    }
}
