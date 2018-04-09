//
//  Instructions.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @TODO: Move this somewhere more obvious
enum KernelInstruction {
    
    // Time
    case tick(Double)
    case pause
    case unpause
    
    // Board
    case addEntity(EntityData)
    case removeEntity(Int)
    case scrollBoard(Double)
    
    // Position
    case updatePositionOffset(Double) // @NOTE: only need to pass in offset, rest of values are calculated dynamically
    
    // Input
    case updateInput(Int)
}

// @TODO: Move this somewhere more obvious
// @NOTE: It seems like the instructions and events
// are identical, so if they never deviate then
// maybe they should just be one in the same
enum KernelEvent {
    
    // Time
    case tick(Double)
    case paused
    case unpaused
    
    // Board
    case barrierAdded(EntityData)
    case barrierRemoved(Int)
    case boardScrolled(Double)
    
    // Position
    case positionUpdated(PositionData) // This one is different
}

// @TODO: Move this somewhere more obvious
struct KernelState {
    var timeState: TimeData
    var boardState: BoardData
    var positionState: PositionData
    var inputState: InputData
    
    static func new() -> KernelState {
        return KernelState(timeState: TimeData.new(),
                           boardState: BoardData.new(),
                           positionState: PositionData.new(),
                           inputState: InputData.new())
    }
    
    // @NOTE: I'm not even really sure if this works correctly...
    // @TODO: Test deep copying
    static func clone(_ state: KernelState) -> KernelState {
        return KernelState(timeState: state.timeState,
                           boardState: state.boardState,
                           positionState: state.positionState,
                           inputState: state.inputState)
    }
}

protocol Kernel {
    // @NOTE: Should send data store protocols
    // and not raw data structures
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction)
}

protocol Rule {
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
