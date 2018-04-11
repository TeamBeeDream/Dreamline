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

class TempSequencer: Sequencer {
    
    // MARK: Private Properties
    
    private var random: Random!
    
    // MARK: Init
    
    static func make(random: Random) -> TempSequencer {
        let instance = TempSequencer()
        instance.random = random
        return instance
    }
    
    // MARK: Sequencer Methods
    
    func nextEntity() -> [(EntityType, EntityData)] {
        // @TEMP
        return [self.createRandomOrb()]
    }
    
    // MARK: Private Methods
    
    // @NOTE: These generation methods should be behind a protocol
    // @IDEA: Have generic functions that produce entities,
    // pass in lane data as [Bool] and produce deterministically
    
    private func createRandomBarrier() -> (EntityType, EntityData) {
        var gates = [Gate]()
        for _ in 1...3 {
            let rand = self.random.next() > 0.5
            gates.append(rand ? .open : .closed)
        }
        return (.barrier, .barrier(gates))
    }
    
    private func createRandomArea() -> (EntityType, EntityData) {
        var areas = [Area]()
        for _ in 1...3 {
            if self.random.next() > 0.5 {
                let rand = self.random.next() > 0.5
                areas.append(rand ? .good : .bad)
            } else { areas.append(.none) }
        }
        return (.area, .area(areas))
    }
    
    private func createRandomThreshold() -> (EntityType, EntityData) {
        let rand = self.random.next() > 0.5
        return (.threshold, .threshold(rand ? .normal : .speed))
    }
    
    private func createRandomOrb() -> (EntityType, EntityData) {
        let type = self.random.next() > 0.5 ? Orb.speedUp : Orb.staminaUp
        let lane = self.random.nextInt(min: 0, max: 3)
        var orbs = [Orb](repeating: .none, count: 3)
        orbs[lane] = type
        return (.orb, .orb(orbs))
    }
}
