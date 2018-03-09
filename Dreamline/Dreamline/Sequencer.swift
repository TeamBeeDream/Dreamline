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

// @REMOVE: this only works with barriers, no longer generic enough
struct Pattern {
    let data: [Gate]
}

protocol Sequencer {
    //func getNextPattern() -> Pattern
    func getNextTrigger() -> TriggerType
    func isDone() -> Bool
}

class RandomSequencer: Sequencer {

    func getNextTrigger() -> TriggerType {
        let random = Double.random()
        
        if random < 0.4 {
            return .empty
        } else if random < 0.7 {
            return .barrier(self.generateRandomBarrier())
        } else {
            return .modifier(self.generateRandomModifierRow())
        }
    }

    func generateRandomModifierRow() -> ModifierRow {
        let randomIndex = Int.random(min: 0, max: 2)
        var modifiers = [ModifierType](repeating: .none, count: 3)
        modifiers[randomIndex] = Double.random() < 0.5 ? .speedUp : .speedDown
        return ModifierRow(pattern: modifiers)
    }
    
    func generateRandomBarrier() -> Barrier {
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
        
        return Barrier(pattern: gates, status: .idle)
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
