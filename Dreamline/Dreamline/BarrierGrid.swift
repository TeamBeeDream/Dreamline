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
        self.id = Barrier.genId()
        self.pattern = pattern
        self.position = position
        self.state = .idle
    }
    
    // @ROBUSTNESS: is having a second init for state a good idea?
    init(id: Int, pattern: Pattern, position: Double, state: BarrierState) {
        self.id = id
        self.pattern = pattern
        self.position = position
        self.state = state
    }
    
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
struct GridProperties {
    var spawnPosition: Double
    var destroyPosition: Double
    var moveSpeed: Double
}

// @TODO: rename
struct BarrierGridState {
    var barriers: [Barrier]
    var totalDistance: Double
}

// @TODO: rename
protocol BarrierGrid {
    func update(state: BarrierGridState, properties: GridProperties, dt: Double) -> BarrierGridState
    func testCollision(state: BarrierGridState, position: Position) -> BarrierGridState
}

// @TODO: better name
class DefaultBarrierGrid: BarrierGrid {
    func update(state: BarrierGridState, properties: GridProperties, dt: Double) -> BarrierGridState {
        let step = dt * properties.moveSpeed
        
        // update all barriers, only include ones that remain active
        var updatedBarriers = [Barrier]()
        for barrier in state.barriers {
            let newPosition = barrier.position + step
            if newPosition > properties.destroyPosition { continue } // exclude
            updatedBarriers.append(Barrier(id: barrier.id,
                                           pattern: barrier.pattern,
                                           position: newPosition,
                                           state: barrier.state)) // @TODO: create clone() method
        }
        
        return BarrierGridState(
            barriers: updatedBarriers,
            totalDistance: state.totalDistance + step)
    }
    
    func testCollision(state: BarrierGridState, position: Position) -> BarrierGridState {
        let verticalRange = 0.05 // @HARDCODED
        
        var updatedBarriers = [Barrier]()
        for barrier in state.barriers {
            let isIdle = barrier.state == .idle
            let withinRange = fabs(barrier.position) < verticalRange
            if !(isIdle && withinRange) {
                updatedBarriers.append(Barrier(id: barrier.id, pattern: barrier.pattern, position: barrier.position, state: barrier.state)) // @TODO: create clone method
                continue
            }
            
            // test collision
            let isGateOpen = barrier.pattern.data[position.lane + 1] == .open // @FIXME
            updatedBarriers.append(
                Barrier(id: barrier.id,
                        pattern: barrier.pattern,
                        position: barrier.position,
                        state: isGateOpen ? .pass : .hit)) // @TODO: create clone method
        }
        
        return BarrierGridState(barriers: updatedBarriers, totalDistance: state.totalDistance)
    }
}
