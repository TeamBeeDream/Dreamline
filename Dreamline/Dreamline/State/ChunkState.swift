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

extension ChunkState {
    static func new() -> ChunkState {
        return ChunkState(type: .empty,
                          difficuly: 0.0,
                          length: 0)
    }
}

struct ChunkState {
    var type: ChunkType
    var difficuly: Double
    var length: Int
}
