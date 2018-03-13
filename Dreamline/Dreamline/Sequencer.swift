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

protocol Sequencer {
    func getNextTrigger(config: GameConfig) -> [TriggerType]
}

// @NOTE: This is a temporary solution
//        It's really only meant for testing before
//        the AuthoredSequencer is complete
class RandomSequencer: Sequencer {

    func getNextTrigger(config: GameConfig) -> [TriggerType] {
        let random = Double.random()
        if random < 0.2 {
            return [.empty]
        } else if random < 0.7 {
            return [.barrier(self.generateRandomBarrier())]
        } else {
            return [.modifier(self.generateRandomModifierRow())]
        }
    }

    func generateRandomModifierRow() -> ModifierRow {
        let randomIndex = Int.random(min: 0, max: 2)
        var modifiers = [ModifierType](repeating: .none, count: 3)
        modifiers[randomIndex] = Double.random() < 0.5 ? .speedUp : .speedDown
        return ModifierRow(modifiers: modifiers)
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
        
        return Barrier(gates: gates)
    }
    
    private func randomGate() -> Gate {
        if Double.random() > 0.5 {
            return .open
        } else {
            return .closed
        }
    }
}

class AuthoredSequencer: Sequencer {
    private enum Pattern {
        case start          // intro at the beginning of every round
        case boost     // at the beginning, gives you choice to speed up right away
        case speedTrap      // a trigger that forces you to change speed
        case tunnel         // a set of barriers that only have one open gate each
        case barrage        // a random set of barriers, difficult to get through
        case pacer          // a random set of barriers, majority of patterns
        case gap            // a gap consisting of empty triggers
    }
    
    private struct Group {
        var pattern: Pattern
        var triggers: [[TriggerType]]
        var index: Int
        
        func clone() -> Group {
            return Group(pattern: self.pattern, triggers: self.triggers, index: self.index)
        }
    }
    
    // internal state
    private var queue = [Group]()
    
    init() {
        // add start pattern to queue
        queue.append(self.newGapPattern(count: 3))
        queue.append(self.newStartPattern())
        queue.append(self.newGapPattern(count: 3))
        queue.append(self.newBoostPattern())
    }
    
    func getNextTrigger(config: GameConfig) -> [TriggerType] {
        
        if queue.isEmpty {
            return [.empty] // @TODO, generate new patterns
        }
        
        // otherwise, pull from queue
        //let group = queue[queue.count-1]
        //var group = queue.popLast()!
        var originalGroup = queue.removeFirst()
        var updatedGroup = originalGroup.clone()
        let nextTrigger = originalGroup.triggers[originalGroup.index]
        
        // if group still has triggers
        if originalGroup.index + 1 < originalGroup.triggers.count {
            updatedGroup.index += 1
            queue.insert(updatedGroup, at: 0)
        }
        
        return nextTrigger
    }
    
    private func newStartPattern() -> Group {
        let barrier: [TriggerType] = [.barrier(Barrier(gates: [.closed, .open, .closed]))]
        let triggers = [[TriggerType]](repeating: barrier, count: 3)
        return Group(pattern: .start, triggers: triggers, index: 0)
    }
    
    private func newGapPattern(count: Int) -> Group {
        let emptyTrigger: [TriggerType] = [.empty]
        let triggers = [[TriggerType]](repeating: emptyTrigger, count: count)
        return Group(pattern: .gap, triggers: triggers, index: 0)
    }
    
    private func newBoostPattern() -> Group {
        let leftBoost: [TriggerType] = [.modifier(ModifierRow(modifiers: [.speedUp, .none, .none]))]
        
        let rightBoost: [TriggerType] = [.modifier(ModifierRow(modifiers: [.none, .none, .speedUp]))]
        
        var triggers = [[TriggerType]]()
        triggers.append(contentsOf: [leftBoost, rightBoost, leftBoost]) // @TODO: Chirality support
        return Group(pattern: .boost, triggers: triggers, index: 0)
    }
}
