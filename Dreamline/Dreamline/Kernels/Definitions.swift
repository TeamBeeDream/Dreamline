//
//  Instructions.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

enum KernelInstruction {
    
    // Time
    case tick(Double)
    case pause
    case unpause
    
    // Board
    case addEntity(EntityData)
    case removeEntity(Int)
    case scrollBoard(Double)
}

enum KernelEvent {
    
    // Time
    case tick
    case paused
    case unpaused
    
    // Board
    case barrierAdded(EntityData)
    case barrierRemoved(Int)
    case boardScrolled(Double)
}

struct KernelState {
    var timeState: TimeData
    var boardState: BoardData
    
    static func new() -> KernelState {
        return KernelState(timeState: TimeData.new(),
                           boardState: BoardData.new())
    }
    
    static func clone(_ state: KernelState) -> KernelState {
        return KernelState(timeState: state.timeState,
                           boardState: state.boardState)
    }
}

protocol Kernel {
    func update(state: KernelState,
                instructions: [KernelInstruction]) -> (KernelState, [KernelEvent])
}

enum RuleFlag {
    
}

protocol Rule {
    func process(state: KernelState,
                 events: [KernelEvent],
                 deltaTime: Double) -> ([RuleFlag], [KernelInstruction])
}

protocol Observer {
    func observe(events: [KernelEvent]) // flags: [RuleFlag]
}
