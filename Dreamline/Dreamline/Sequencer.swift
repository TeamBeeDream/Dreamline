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
        // @TEMP: Generate random barriers
        var gates = [Bool]()
        var areas = [Bool]()
        for _ in 1...3 {
            let rand = self.random.next() > 0.5
            gates.append(rand)
            areas.append(!rand) // Area bools are flipped
        }
        return [(.area, .area(areas)), (.barrier, .barrier(gates))]
    }
}
