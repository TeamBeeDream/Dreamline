//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Sequencer {
    func generateEntities(numberOfBarriers: Int, density: Double) -> [(EntityType, EntityData)]
}

class TempBarrierSequencer: Sequencer {
    
    static func make() -> TempBarrierSequencer {
        let instance = TempBarrierSequencer()
        return instance
    }
    
    func generateEntities(numberOfBarriers: Int, density: Double) -> [(EntityType, EntityData)] {
        var entities = [(EntityType, EntityData)]()
        var totalBarriers = 0
        while totalBarriers < numberOfBarriers {
            if self.shouldPlaceBarrier(probability: density) {
                entities.append(self.generateRandomBarrier())
                totalBarriers += 1
            } else {
                entities.append((.blank, .blank))
            }
        }
        entities.append((.threshold, .threshold(.roundOver))) // @HACK
        return entities
    }
    
    func shouldPlaceBarrier(probability: Double) -> Bool {
        return RealRandom().next() < probability
    }
    
    func generateRandomBarrier() -> (EntityType, EntityData) {
        let numberOfOpenGates = RealRandom().nextBool() ? 1 : 2 // gross
        let gates = self.generateRandomGateArray(numberOfOpenGates: numberOfOpenGates)
        return (.barrier, .barrier(gates))
    }
    
    func generateRandomGateArray(numberOfOpenGates: Int) -> [Gate] {
        var gates: [Gate] = [.closed, .closed, .closed]
        for _ in 1...numberOfOpenGates {
            let randomLane = RealRandom().nextInt(min: 0, max: 3)
            gates[randomLane] = .open
        }
        return gates
    }
}
