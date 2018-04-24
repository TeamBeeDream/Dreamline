//
//  Instructions.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

// @TODO: Move this somewhere more obvious
enum KernelInstruction {
    
    // Time
    case tick(Double)
    case pause
    case unpause
    case resetTime
    
    // Board
    case addEntity(Entity)
    case removeEntity(Int)
    case scrollBoard(Double)
    case updateEntityState(Int, EntityState)
    case clearBoard
    
    // Position
    case updatePositionOffset(Double) // @NOTE: only need to pass in offset, rest of values are calculated dynamically
    
    // Input
    case updateInput(Int)
    case addTap
    
    // Stamina
    case incrementStamina
    case decrementStamina
    
    // Speed
    case updateSpeed(Double)
    
    // Score
    case addScore(Int)
    
    // Game
    case roundComplete
    case updatePhase(Phase)
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
    case entityAdded(Entity)
    case entityRemoved(Int)
    case entityMoved(Entity, Double)
    case entityStateChanged(Entity)
    case boardScrolled(Double, Double)
    
    // Position
    case positionUpdated(PositionData) // @CLEANUP: Pass generic variables?
    
    // Input
    case inputChanged(Int)
    case tapAdded
    
    // Stamina
    case staminaUpdated(Int)
    
    // Speed
    case speedUpdated(Double)
    
    // Score
    case scoreUpdated(Int)
    
    // Phase
    case phaseChanged(Phase)
    case roundComplete(ScoreData)
}

// @TODO: Move this somewhere more obvious
struct KernelState {
    var timeState: TimeData
    var boardState: BoardData
    var positionState: PositionData
    var inputState: InputData
    var staminaState: StaminaData
    var speedState: SpeedData
    var scoreState: ScoreData
    var phaseState: Phase
    
    static func new() -> KernelState {
        return KernelState(timeState: TimeData.new(),
                           boardState: BoardData.new(),
                           positionState: PositionData.new(),
                           inputState: InputData.new(),
                           staminaState: StaminaData.new(),
                           speedState: SpeedData.new(),
                           scoreState: ScoreData.new(),
                           phaseState: .none) // awk
    }
}

// @NOTE: Stateless
protocol Kernel {
    // @NOTE: Should send data store protocols
    // and not raw data structures
    func update(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction)
}

// @NOTE: Stateful
protocol Rule {
    func sync(state: KernelState)
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double)
    // @NOTE: This deltaTime is real time, need to use .tick event to get
    // in-engine time
}

// @NOTE: Stateful
protocol Observer {
    func sync(state: KernelState)
    func observe(events: [KernelEvent])
}
