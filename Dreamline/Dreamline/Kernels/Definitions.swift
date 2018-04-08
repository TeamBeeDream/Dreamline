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
    case tick(Double)
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
    
    // This is weird
    static func sync(_ state: inout KernelState, with match: KernelState) {
        state.timeState.deltaTime = match.timeState.deltaTime
        state.timeState.frameNumber = match.timeState.frameNumber
        state.timeState.paused = match.timeState.paused
        state.timeState.timeSinceBeginning = match.timeState.timeSinceBeginning
        
        state.boardState.layout = match.boardState.layout
        state.boardState.scrollDistance = match.boardState.scrollDistance
        state.boardState.entities = match.boardState.entities
    }
}

protocol Kernel {
    /*
    func update(state: KernelState,
                instructions: [KernelInstruction]) -> (KernelState, [KernelEvent])
    */
    
    // @NOTE: Should send data store protocols
    // and not raw data structures
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction)
                //instructions: [KernelInstruction])
}

enum RuleFlag {
    
}

protocol Rule {
    /*
    func process(state: KernelState,
                 events: [KernelEvent],
                 deltaTime: Double) -> ([RuleFlag], [KernelInstruction])
    */
    
    func mutate(state: inout KernelState,
                 events: inout [KernelEvent],
                 instructions: inout [KernelInstruction],
                 deltaTime: Double)
    // @NOTE: This deltaTime is real time, need to use .tick event to get
    // in-engine time
}

protocol Observer {
    func observe(events: [KernelEvent]) // flags: [RuleFlag]
}
