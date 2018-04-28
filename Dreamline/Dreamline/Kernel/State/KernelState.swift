//
//  Data.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct KernelState {
    var time: TimeState
    var board: BoardState
    var position: PositionState
    var chunk: ChunkState
    var flowControl: FlowControlState
    var health: HealthState
}

extension KernelState {
    static func new() -> KernelState {
        return KernelState(time: TimeState.new(),
                           board: BoardState.new(),
                           position: PositionState.new(),
                           chunk: ChunkState.new(),
                           flowControl: FlowControlState.new(),
                           health: HealthState.new())
    }
    
    static func master() -> KernelState {
        var boardState = BoardState.new()
        boardState.layout = BoardLayout(playerPosition: 0.2, upperBound: 1.0, lowerBound: -1.0)
        boardState.scrollSpeed = 1.0
        boardState.distanceBetweenEntities = 0.5
        
        let chunkState = ChunkState(type: .barriers, difficuly: 0.2, length: 5)
        
        return KernelState(time: TimeState.new(),
                           board: boardState,
                           position: PositionState.new(),
                           chunk: chunkState,
                           flowControl: FlowControlState.new(),
                           health: HealthState.new())
    }
}
