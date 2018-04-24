//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct SequencerParams {
    var density: Double
    var length: Int
}

protocol Sequencer {
    func generateEntities(params: SequencerParams) -> [(EntityType, EntityData)]
}

class TempBarrierSequencer: Sequencer {
    
    static func make() -> TempBarrierSequencer {
        let instance = TempBarrierSequencer()
        return instance
    }
    
    func generateEntities(params: SequencerParams) -> [(EntityType, EntityData)] {
        var entities = [(EntityType, EntityData)]()
        for _ in 1...params.length {
            if self.shouldPlaceBarrier(probability: params.density) {
                entities.append(self.generateRandomBarrier())
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
            let randomLane = RealRandom().nextInt(min: 0, max: 2)
            gates[randomLane] = .open
        }
        return gates
    }
}
