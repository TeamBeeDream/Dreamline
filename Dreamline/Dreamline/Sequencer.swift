//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Sequencer {
    func nextEntity() -> [EntityType]
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
    
    func nextEntity() -> [EntityType] {
        // @TEMP: Generate random barriers
        var gates = [Bool]()
        for _ in 1...3 {
            gates.append(self.random.next() > 0.5)
        }
        return [.barrier(gates)]
    }
}
