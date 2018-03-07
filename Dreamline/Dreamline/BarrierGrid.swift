//
//  BarrierGrid.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @TODO: rename
enum BarrierState {
    case idle
    case pass
    case hit
}

struct Barrier {
    let id: Int
    let pattern: Pattern
    var position: Double
    var state: BarrierState
    
    init(pattern: Pattern, position: Double) {
        self.id = Barrier.genId()   // auto-gen new id
        self.pattern = pattern
        self.position = position
        self.state = .idle
    }
}

extension Barrier {
    private init(id: Int, pattern: Pattern, position: Double, state: BarrierState) {
        self.id = id
        self.pattern = pattern
        self.position = position
        self.state = state
    }
    
    func clone() -> Barrier {
        return Barrier(id: self.id,
                       pattern: self.pattern,
                       position: self.position,
                       state: self.state)
    }
}

extension Barrier {
    // @TODO: determine if there is a better way to
    // generate a unique id for barriers
    static var parity: Int = 0
    static func genId() -> Int {
        let id = Barrier.parity
        Barrier.parity += 1
        return id
    }
}

// @TODO: rename
// @TODO: add player position
// @TODO: make all positions absolute
struct GridLayout {
    var   spawnPosition: Double
    var destroyPosition: Double
    var  playerPosition: Double
    var laneOffset: Double
    
    var moveSpeed: Double // @TODO: this probably shouldn't be here
}

// @TODO: rename
struct BarrierGridState {
    var barriers: [Barrier]
    var totalDistance: Double
    var distanceSinceLastBarrier: Double
    var distanceBetweenBarriers: Double
}

// @TODO: rename
protocol BarrierGrid {
    func update(state: BarrierGridState, layout: GridLayout, sequencer: Sequencer, position: Position, dt: Double) -> (BarrierGridState, [Event])
}

// @TODO: better name
class DefaultBarrierGrid: BarrierGrid {
    func update(state: BarrierGridState, layout: GridLayout, sequencer: Sequencer, position: Position, dt: Double) -> (BarrierGridState, [Event]) {
        
        let step = dt * layout.moveSpeed // @TODO: weird
        var events = [Event]()
        
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
            let newBarrier = Barrier(
                pattern: sequencer.getNextPattern(),
                position: layout.spawnPosition)
            remainingBarriers.append(newBarrier) // @CLEANUP
            events.append(.barrierAdded(newBarrier))
        }
        
        // COLLISION
        let verticalRange = 0.05 // @HARDCODED
        
        var updatedBarriers = [Barrier]()
        for barrier in remainingBarriers {
            let isIdle = barrier.state == .idle
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
                newBarrier.state = .hit
                events.append(.barrierHit(barrier.id))
            } else {
                newBarrier.state = isGateOpen ? .pass : .hit
                events.append(isGateOpen ? .barrierPass(barrier.id) : .barrierHit(barrier.id))
            }
            updatedBarriers.append(newBarrier)
        }
        
        
        let updatedState = BarrierGridState(
            barriers: updatedBarriers,
            totalDistance: state.totalDistance + step,
            distanceSinceLastBarrier: distance,
            distanceBetweenBarriers: state.distanceBetweenBarriers) // @TODO: add clone method
        return (updatedState, events)
    }
}
