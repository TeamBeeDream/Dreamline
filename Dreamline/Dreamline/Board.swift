//
//  BarrierGrid.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

enum BarrierStatus {
    case idle // @RENAME
    case pass
    case hit
}

struct Barrier {
    let id: Int
    let pattern: Pattern
    var position: Double
    var status: BarrierStatus
}

extension Barrier {
    func clone() -> Barrier {
        return Barrier(id: self.id,
                       pattern: self.pattern,
                       position: self.position,
                       status: self.status)
    }
}

struct BoardLayout {
    var spawnPosition: Double
    var destroyPosition: Double
    var playerPosition: Double
    var laneOffset: Double
}

struct BoardState {
    var barriers: [Barrier]
    var totalDistance: Double
    var distanceSinceLastBarrier: Double
    var distanceBetweenBarriers: Double // @TODO: might make this a config
    var barrierCount: Int
    
    init(distanceBetweenBarriers: Double) {
        self.barriers = [Barrier]()
        self.totalDistance = 0.0
        self.distanceBetweenBarriers = distanceBetweenBarriers
        self.distanceSinceLastBarrier = 0.0
        self.barrierCount = 0
    }
}

// @CLEANUP, should probably use factory method
extension BoardState {
    private init(barriers: [Barrier],
                 totalDistance: Double,
                 distanceSinceLastBarrier: Double,
                 distanceBetweenBarriers: Double,
                 barrierCount: Int) {
        self.barriers = barriers
        self.totalDistance = totalDistance
        self.distanceSinceLastBarrier = distanceSinceLastBarrier
        self.distanceBetweenBarriers = distanceBetweenBarriers
        self.barrierCount = barrierCount
    }
    
    func clone() -> BoardState {
        return BoardState(barriers: self.barriers,
                          totalDistance: self.totalDistance,
                          distanceSinceLastBarrier: self.distanceSinceLastBarrier,
                          distanceBetweenBarriers: self.distanceBetweenBarriers,
                          barrierCount: self.barrierCount)
    }
}

protocol Board {
    func update(state: BoardState,
                config: GameConfig,
                layout: BoardLayout,
                sequencer: Sequencer,
                position: Position,
                dt: Double) -> (BoardState, [Event])
}

// @TODO: better name
// the name should reflect the specific rules this implementation follows:
// - continuously scrolls
// - adds new barriers
// - removes old barriers
// - handles collisions
class DefaultBoard: Board {
    
    // @CLEANUP: this method needs another pass for clarity
    func update(state: BoardState,
                config: GameConfig,
                layout: BoardLayout,
                sequencer: Sequencer,
                position: Position,
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
        // @TODO: need better collision detection,
        // if the board is scrolling too fast then instantaneous checking is not precise enough
        // draw a line from player's previous position and do a line collision across the barrier
        let verticalRange = 0.05 // @HARDCODED
        
        var updatedBarriers = [Barrier]()
        for barrier in remainingBarriers {
            let isIdle = barrier.status == .idle
            let withinRange = fabs(barrier.position - layout.playerPosition) < verticalRange
            if !(isIdle && withinRange) {
                updatedBarriers.append(barrier.clone())
                continue
            }
            
            // test collision
            let withinTolerance = position.withinTolerance
            let isGateOpen = barrier.pattern.data[position.lane + 1] == .open // @FIXME
            var newBarrier = barrier.clone()
            
            if !withinTolerance {
                newBarrier.status = .hit
                events.append(.barrierHit(barrier.id))
            } else {
                newBarrier.status = isGateOpen ? .pass : .hit
                events.append(isGateOpen ? .barrierPass(barrier.id) : .barrierHit(barrier.id))
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
}
