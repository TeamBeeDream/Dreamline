//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

enum Gate {
    case open
    case closed
}

struct Pattern {
    let data: [Gate]
}

protocol Sequencer {
    func getNextPattern() -> Pattern
    func isDone() -> Bool
}

class RandomSequencer: Sequencer {
    
    func getNextPattern() -> Pattern {
        var gates = [Gate]()
        var allClosed = true
        var allOpen = true
        for i in 1...3 {
            let gate = self.randomGate()
            if gate == .open { allClosed = allClosed && false }
            if gate == .closed { allOpen = allOpen && false }
            
            // @CLEANUP: this code ensures that every gate has at least
            // one opening or one closing, hard to understand
            if i == 3 && allClosed { gates.append(.open) }
            else if i == 3 && allOpen { gates.append(.closed) }
            else { gates.append(gate) }
        }
        
        return Pattern(data: gates)
    }
    
    func isDone() -> Bool {
        return false // @HARDCODED: random sequencer will never run out of patterns
    }
    
    private func randomGate() -> Gate {
        if Double.random() > 0.5 {
            return .open
        } else {
            return .closed
        }
    }
}
