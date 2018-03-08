//
//  BarrierGrid.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import UIKit

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
    
    // @CLEANUP: this method needs another pass for clarity
    func update(state: BoardState,
                config: GameConfig,
                layout: BoardLayout,
                sequencer: Sequencer,
                originalPosition: Position,
                updatedPosition: Position,
                dt: Double) -> (BoardState, [Event]) {
        
        let step = dt * config.boardScrollSpeed
        var events = [Event]()
        var newBarrierCount = state.barrierCount
        //var prevBarrierPositions = [Int: Double]()
        
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
            //prevBarrierPositions[barrier.id] = barrier.position // cache locally
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
            // @TODO: make better method for checking player collision
            // can probably use positioner to getPosition at xPos, and see
            // which lane it's closest to.  Need to check for multiple open gates
            // if crossing lanes, check for within tolerance, otherwise don't
            let distCenter = fabs(0 - xPos)
            let distLeft = fabs(-layout.laneOffset - xPos)
            let distRight = fabs(layout.laneOffset - xPos)
            let minD = min(min(distLeft, distRight), distCenter)
            var nearest = 0
            if minD == distCenter { nearest = Lane.center.rawValue }
            if minD == distLeft { nearest = Lane.left.rawValue }
            if minD == distRight { nearest = Lane.right.rawValue }
            
            var newBarrier = barrier.clone()
            
            if barrier.pattern.data[nearest+1] == .open {
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
}
