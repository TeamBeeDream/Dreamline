//
//  BarrierGrid.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import UIKit

// @RENAME: this is more than just the type, it IS the data
enum TriggerType {
    case barrier(Barrier)
    case modifier(ModifierRow)
    case empty // not sure if this is a good idea
}

// @RENAME: this is close
// name needs to imply that it's a line that you cross
// and when you cross it, it changes something about the state
struct Trigger {
    let id: Int
    var position: Double
    var status: TriggerStatus
    var type: TriggerType
}

extension Trigger {
    func clone() -> Trigger {
        return Trigger(id: self.id,
                       position: self.position,
                       status: self.status,
                       type: self.type)
    }
}

enum TriggerStatus {
    case idle // @RENAME
    case pass
    case hit
}

struct Barrier {
    let gates: [Gate] // only this left, huh
}

enum ModifierType {
    case speedUp
    case speedDown
    case none // this is a little weird
}

struct ModifierRow {
    let modifiers: [ModifierType]
}

extension Barrier {
    func clone() -> Barrier {
        return Barrier(gates: self.gates)
    }
}

struct BoardLayout {
    var spawnPosition: Double
    var destroyPosition: Double
    var playerPosition: Double
    var laneOffset: Double
}

struct BoardState {
    var triggers: [Trigger]
    var totalDistance: Double
    var distanceSinceLastTrigger: Double
    var totalTriggerCount: Int // @CLEANUP: this is used for assigning unique int ids
    
    init() {
        self.triggers = [Trigger]()
        self.totalDistance = 0.0
        self.distanceSinceLastTrigger = 0.0
        self.totalTriggerCount = 0
    }
}

// @CLEANUP, should probably use factory method
extension BoardState {
    private init(triggers: [Trigger],
                 totalDistance: Double,
                 totalTriggerCount: Int,
                 distanceSinceLastTrigger: Double) {
        
        self.triggers = triggers
        self.totalDistance = totalDistance
        self.totalTriggerCount = totalTriggerCount
        self.distanceSinceLastTrigger = distanceSinceLastTrigger
    }
    
    func clone() -> BoardState {
        return BoardState(triggers: self.triggers,
                          totalDistance: self.totalDistance,
                          totalTriggerCount: self.totalTriggerCount,
                          distanceSinceLastTrigger: self.distanceSinceLastTrigger)
    }
}

protocol Board {
    func update(state: BoardState,
                config: GameConfig,
                layout: BoardLayout,
                sequencer: Sequencer,
                positioner: Positioner,
                originalPosition: Position,
                updatedPosition: Position,
                dt: Double) -> (BoardState, [Event])
}

// @TODO: better name
// the name should reflect the specific rules this implementation follows:
// - continuously scrolls
// - adds new barriers
// - removes old barriers
// - handles collisions
class DefaultBoard: Board {
    
    func update(state: BoardState,
                config: GameConfig,
                layout: BoardLayout,
                sequencer: Sequencer,
                positioner: Positioner,
                originalPosition: Position,
                updatedPosition: Position,
                dt: Double) -> (BoardState, [Event]) {
        
        // constants
        let step = dt * ScrollSpeedData.getData()[config.boardScrollSpeed]!.speed
        
        // updated information @CLEANUP
        var raisedEvents = [Event]()
        var updatedTotalTriggerCount = state.totalTriggerCount
        
        // step: move all triggers
        // @TODO: can probably move this into a private func
        var updatedTriggers_Moved = [Trigger]()
        for trigger in state.triggers {
            let updatedPosition = trigger.position + step
            if updatedPosition > layout.destroyPosition {
                // if below the cutoff, exclude from the updated list
                // and raise a 'destroyed' event
                raisedEvents.append(.triggerDestroyed(trigger.id))
                continue
            } else {
                // if still active, update position
                // and add to updated list
                var updatedTrigger = trigger.clone()
                updatedTrigger.position = updatedPosition
                updatedTriggers_Moved.append(updatedTrigger)
            }
        }
        
        // step: add new trigger if necessary
        // @TODO: make this deterministic
        var updatedTriggers_Added = [Trigger]()
        var distance = state.distanceSinceLastTrigger + step
        if distance > config.boardDistanceBetweenTriggers {
            distance = 0.0 // @HACK: this is used later in this function, very fragile
            
            let triggers = sequencer.getNextTrigger(config: config)
            for triggerType in triggers {
                updatedTotalTriggerCount += 1
                let newTrigger = Trigger(id: updatedTotalTriggerCount,
                                         position: layout.spawnPosition,
                                         status: .idle,
                                         type: triggerType)
                updatedTriggers_Added.append(newTrigger)
                raisedEvents.append(.triggerAdded(newTrigger))
            }
        }
        
        // @TODO: step: handle collision and raise events
        // @CLEANUP: the nested switches are hard to read
        var updatedTriggers_Collision = [Trigger]()
        for trigger in updatedTriggers_Moved { // this is post-move
            
            var updatedTrigger = trigger.clone()
            
            switch (trigger.type) {
            case .barrier(let barrier):
                
                let updatedStatus = barrierCollisionTest(barrier: barrier,
                                        position: trigger.position,
                                        step: step,
                                        layout: layout,
                                        originalPosition: originalPosition,
                                        updatedPosition: updatedPosition,
                                        positioner: positioner,
                                        config: config)
                
                switch (updatedStatus) {
                case .idle:
                    break
                case .hit:
                    raisedEvents.append(.barrierHit(trigger.id))
                case .pass:
                    raisedEvents.append(.barrierPass(trigger.id))
                }
                
                updatedTrigger.status = updatedStatus
                
            case .modifier(let row):
                
                let (updatedStatus, modifierType) = modifierDidCollide(row: row,
                                                       position: trigger.position,
                                                       step: step,
                                                       layout: layout,
                                                       positioner: positioner,
                                                       originalPosition: originalPosition,
                                                       updatedPosition: updatedPosition,
                                                       config: config) // too many
                
                switch (updatedStatus) {
                case .hit:
                    raisedEvents.append(.modifierGet(trigger.id, modifierType))
                default:
                    break
                }
                
                updatedTrigger.status = updatedStatus
                
            default:
                break
            }
            
            updatedTriggers_Collision.append(updatedTrigger)
        }
        
        // composite updated state
        var updatedTriggers = [Trigger]()
        updatedTriggers.append(contentsOf: updatedTriggers_Moved)
        updatedTriggers.append(contentsOf: updatedTriggers_Added)
        
        var updatedState = state.clone() // memory inefficient
        updatedState.triggers = updatedTriggers
        updatedState.totalTriggerCount = updatedTotalTriggerCount
        updatedState.distanceSinceLastTrigger = distance // @CLEANUP
        updatedState.totalDistance = state.totalDistance + step
        
        return (updatedState, raisedEvents)
    }
    
    // @CLEANUP: reduce number of params
    // @CLEANUP: also, this function is kinda ugly
    private func barrierCollisionTest(barrier: Barrier,
                                      position: Double,
                                      step: Double,
                                      layout: BoardLayout,
                                      originalPosition: Position,
                                      updatedPosition: Position,
                                      positioner: Positioner,
                                      config: GameConfig) -> TriggerStatus {
        let barrierY0 = position - step
        let barrierY1 = position
        
        // determine if player crossed barrier
        let crossed = barrierY0 < layout.playerPosition && barrierY1 > layout.playerPosition
        if !crossed { // didn't collide
            return .idle // no change
        }
        
        // calculate pass through
        let relOriginY = layout.playerPosition - barrierY0
        let t = relOriginY / step
        let xPos = lerp(t, min: originalPosition.offset, max: updatedPosition.offset)
        
        // sample barrier at xPos
        let pState = PositionerState(currentOffset: xPos) // this is silly
        let dPos = positioner.getPosition(state: pState, config: config)
        
        let crossedLanes = originalPosition.lane != updatedPosition.lane
        let withinTolerance = dPos.withinTolerance
        let nearest = dPos.lane + 1
        
        var didHit = false
        
        if crossedLanes {
            // check if both lanes are open
            let open0 = barrier.gates[originalPosition.lane + 1] == .open
            let open1 = barrier.gates[updatedPosition.lane + 1] == .open
            if open0 && open1 {
                // no need to check tolerance
                didHit = barrier.gates[nearest] != .open
            } else {
                // include tolerance
                didHit = barrier.gates[nearest] != .open && withinTolerance
            }
        } else {
            // simple check
            didHit = barrier.gates[nearest] != .open
        }
        
        // didHit is not a good name
        if !didHit { return .pass }
        else { return .hit }
    }
    
    private func modifierDidCollide(row: ModifierRow,
                                    position: Double,
                                    step: Double,
                                    layout: BoardLayout,
                                    positioner: Positioner,
                                    originalPosition: Position,
                                    updatedPosition: Position,
                                    config: GameConfig) -> (TriggerStatus, ModifierType) {
        let barrierY0 = position - step
        let barrierY1 = position
        
        // determine if player crossed barrier
        let crossed = barrierY0 < layout.playerPosition && barrierY1 > layout.playerPosition
        if !crossed { // didn't collide
            return (.idle, .none) // no change
        }
        
        // calculate pass through
        let relOriginY = layout.playerPosition - barrierY0
        let t = relOriginY / step
        let xPos = lerp(t, min: originalPosition.offset, max: updatedPosition.offset)
        
        // sample barrier at xPos
        let pState = PositionerState(currentOffset: xPos) // this is silly
        let dPos = positioner.getPosition(state: pState, config: config)
        
        let withinTolerance = dPos.withinTolerance
        let nearest = dPos.lane + 1
        
        // @RENAME: this is the actual modifier that you collided with (its type)
        let hit = row.modifiers[nearest]
        
        if hit == .none {
            return (.pass, hit)
        } else {
            return withinTolerance ? (.hit, hit) : (.pass, hit)
        }
    }
}
