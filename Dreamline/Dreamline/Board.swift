//
//  BarrierGrid.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import UIKit

enum TriggerType {
    case barrier(Barrier)
    case modifier(ModifierRow)
}

// @RENAME: this is close
// name needs to imply that it's a line that you cross
// and when you cross it, it changes something about the state
struct Trigger {
    let id: Int
    var position: Double
    var type: TriggerType
}

extension Trigger {
    func clone() -> Trigger {
        return Trigger(id: self.id, position: self.position, type: self.type)
    }
}

enum BarrierStatus {
    case idle // @RENAME
    case pass
    case hit
}

struct Barrier {
    let pattern: [Gate]
    var status: BarrierStatus
}

enum ModifierType {
    case speedUp
    case speedDown
}

struct ModifierRow {
    let pattern: [ModifierType]
}

extension Barrier {
    func clone() -> Barrier {
        return Barrier(pattern: self.pattern, status: self.status)
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
        let step = dt * config.boardScrollSpeed
        
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
            updatedTotalTriggerCount += 1
            let barrier = Barrier(pattern: sequencer.getNextPattern().data, status: .idle)
            let newTrigger = Trigger(id: updatedTotalTriggerCount,
                                     position: layout.spawnPosition,
                                     type: .barrier(barrier)) // @HARDCODED
            updatedTriggers_Added.append(newTrigger)
            raisedEvents.append(.triggerAdded(newTrigger))
        }
        
        // @TODO: step: handle collision and raise events
        
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
    
    // @CLEANUP: remove this when collision is reimplemented
    // this is just here for reference
    /*
    func update(state: BoardState,
                config: GameConfig,
                layout: BoardLayout,
                sequencer: Sequencer,
                positioner: Positioner,
                originalPosition: Position,
                updatedPosition: Position,
                dt: Double) -> (BoardState, [Event]) {
        
        let step = dt * config.boardScrollSpeed
        var events = [Event]()
        var newBarrierCount = state.barrierCount
        
        // MOVE ALL BARRIERS, DESTROY INVALID ONES
        var remainingBarriers = [Barrier]()
        for barrier in state.barriers {
            let newPosition = barrier.position + step
            if newPosition > layout.destroyPosition {
                events.append(.barrierDestroyed(barrier.id))
                continue
            }
            
            var newBarrier = barrier.clone()
            newBarrier.position = newPosition
            remainingBarriers.append(newBarrier)
        }
        
        // ADD NEW BARRIER IF NECESSARY
        // @FIXME: make sure new barrier is positioned correctly
        var distance = state.distanceSinceLastBarrier + step
        if distance > state.distanceBetweenBarriers {
            distance = 0.0 // @HACK
            newBarrierCount += 1
            let newBarrier = Barrier(
                id: newBarrierCount,
                pattern: sequencer.getNextPattern(),
                position: layout.spawnPosition,
                status: .idle)
            remainingBarriers.append(newBarrier) // @CLEANUP
            events.append(.barrierAdded(newBarrier))
        }
        
        // COLLISION
        // @CLEANUP: this is so hard to understand
        var updatedBarriers = [Barrier]()
        for barrier in remainingBarriers {
            
            let barrierY0 = barrier.position - step
            let barrierY1 = barrier.position
            
            // determine if player crossed barrier
            let crossed = barrierY0 < layout.playerPosition && barrierY1 > layout.playerPosition
            if !crossed { // didn't collide
                updatedBarriers.append(barrier.clone()) // this is weird
                continue
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
            
            var newBarrier = barrier.clone()
            var didHit = false
            
            if crossedLanes {
                // check if both lanes are open
                let open0 = barrier.pattern.data[originalPosition.lane + 1] == .open
                let open1 = barrier.pattern.data[updatedPosition.lane + 1] == .open
                if open0 && open1 {
                    // no need to check tolerance
                    didHit = barrier.pattern.data[nearest] != .open
                } else {
                    // include tolerance
                    didHit = barrier.pattern.data[nearest] != .open && withinTolerance
                }
            } else {
                // simple check
                didHit = barrier.pattern.data[nearest] != .open
            }
            
            
            if !didHit {
                newBarrier.status = .pass
                events.append(.barrierPass(newBarrier.id))
            } else {
                newBarrier.status = .hit
                events.append(.barrierHit(newBarrier.id))
            }
            updatedBarriers.append(newBarrier)
        }
        
        var updatedState = state.clone()
        updatedState.barriers = updatedBarriers
        updatedState.barrierCount = newBarrierCount
        updatedState.totalDistance = state.totalDistance + step
        updatedState.distanceSinceLastBarrier = distance
        return (updatedState, events)
    }
 */
}
