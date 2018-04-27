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
}
