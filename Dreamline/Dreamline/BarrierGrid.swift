//
//  BarrierGrid.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct Barrier {
    let id: Int
    let pattern: Pattern
    var position: Double
    
    init(pattern: Pattern, position: Double) {
        self.id = Barrier.genId()
        self.pattern = pattern
        self.position = position
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
            updatedBarriers.append(Barrier(pattern: barrier.pattern, position: newPosition))
        }
        
        return BarrierGridState(
            barriers: updatedBarriers,
            totalDistance: state.totalDistance + step)
    }
}
