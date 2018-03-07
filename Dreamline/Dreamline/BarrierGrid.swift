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
}

// @TODO: rename
protocol BarrierGrid {
    func update(state: BarrierGridState, layout: GridLayout, dt: Double) -> BarrierGridState
    func testCollision(state: BarrierGridState, layout: GridLayout, position: Position) -> BarrierGridState
}

// @TODO: better name
class DefaultBarrierGrid: BarrierGrid {
    func update(state: BarrierGridState, layout: GridLayout, dt: Double) -> BarrierGridState {
        let step = dt * layout.moveSpeed // @TODO: weird
        
        // update all barriers, only include ones that remain active
        var updatedBarriers = [Barrier]()
        for barrier in state.barriers {
            let newPosition = barrier.position + step
            if newPosition > layout.destroyPosition { continue } // exclude
            
            var newBarrier = barrier.clone()
            newBarrier.position = newPosition
            updatedBarriers.append(newBarrier)
        }
        
        return BarrierGridState(
            barriers: updatedBarriers,
            totalDistance: state.totalDistance + step)
    }
    
    func testCollision(state: BarrierGridState, layout: GridLayout, position: Position) -> BarrierGridState {
        let verticalRange = 0.05 // @HARDCODED
        
        var updatedBarriers = [Barrier]()
        for barrier in state.barriers {
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
            if !withinTolerance { newBarrier.state = .hit }
            else { newBarrier.state = isGateOpen ? .pass : .hit }
            updatedBarriers.append(newBarrier)
        }
        
        return BarrierGridState(barriers: updatedBarriers, totalDistance: state.totalDistance)
    }
}
