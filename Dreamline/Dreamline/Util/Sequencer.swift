//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @TODO: Find place for this file

protocol Sequencer {
    func nextEntity() -> [(EntityType, EntityData)]
}

class TempBarrierSequencer: Sequencer {
    
    private var density: Double!
    
    static func make(density: Double) -> TempBarrierSequencer {
        let instance = TempBarrierSequencer()
        instance.density = density
        return instance
    }
    
    func nextEntity() -> [(EntityType, EntityData)] {
        if !self.shouldPlaceBarrier(probability: self.density) {
            return []
        }
        
        return [self.generateRandomBarrier()]
    }
    
    func shouldPlaceBarrier(probability: Double) -> Bool {
        return RealRandom().next() > probability
    }
    
    func generateRandomBarrier() -> (EntityType, EntityData) {
        let numberOfOpenGates = RealRandom().nextBool() ? 1 : 2 // gross
        let gates = self.generateRandomGateArray(numberOfOpenGates: numberOfOpenGates)
        return (.barrier, .barrier(gates))
    }
    
    func generateRandomGateArray(numberOfOpenGates: Int) -> [Gate] {
        var gates: [Gate] = [.closed, .closed, .closed]
        for _ in 1...numberOfOpenGates {
            let randomLane = RealRandom().nextInt(min: 0, max: 2)
            gates[randomLane] = .open
        }
        return gates
    }
}
