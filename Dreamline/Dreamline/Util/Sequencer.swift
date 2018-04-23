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
    private var current: Int = 0 // @TEMP
    private var buffer: [(EntityType, EntityData)]!
    
    // MARK: Init
    
    static func make(random: Random) -> TempSequencer {
        let instance = TempSequencer()
        instance.random = random
        
        // @TEMP
        instance.generateFullPattern()
        
        return instance
    }
    
    // MARK: Sequencer Methods
    
    func nextEntity() -> [(EntityType, EntityData)] {
        // @TEMP
//        self.current += 1
//        if self.current != 10 {
//            return [self.createRandomOrb()]
//        } else {
//            return [self.createRoundOverThreshold()]
//        }
        if self.current >= self.buffer.count { return [] }
        let entity = self.buffer[self.current]
        self.current += 1
        return [entity]
    }
    
    // MARK: Private Methods
    
    private func generateFullPattern() {
        self.buffer = TempWallGenerator().generate(length: 50)
    }
    
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
    
    // @TEMP
    private func createRoundOverThreshold() -> (EntityType, EntityData) {
        return (.threshold, .threshold(.roundOver))
    }
    
    private func createRandomOrb() -> (EntityType, EntityData) {
        let type = self.random.next() > 0.5 ? Orb.speedUp : Orb.staminaUp
        let lane = self.random.nextInt(min: 0, max: 3)
        var orbs = [Orb](repeating: .none, count: 3)
        orbs[lane] = type
        return (.orb, .orb(orbs))
    }
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
