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
        case boost          // at the beginning, gives you choice to speed up right away
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
            // @TODO: Sequence patterns dynamically
            queue.append(self.newTunnelPattern())
            queue.append(self.newGapPattern(count: 3))
            queue.append(self.newBarragePattern())
            queue.append(self.newGapPattern(count: 3))
            queue.append(self.newPacerPattern())
            queue.append(self.newGapPattern(count: 3))
            queue.append(self.newSpeedTrapPattern())
            queue.append(self.newGapPattern(count: 3))
        }
        
        // otherwise, pull from queue
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
        
        let triggers = [leftBoost, rightBoost, leftBoost] // @TODO: Chirality support
        return Group(pattern: .boost, triggers: triggers, index: 0)
    }
    
    private func newSpeedTrapPattern() -> Group {
        let barrier: TriggerType = .barrier(Barrier(gates: [.closed, .open, .closed]))
        let modifier: TriggerType = .modifier(ModifierRow(modifiers: [.none, .speedUp, .none]))
        
        let triggers = [[barrier, modifier]]
        return Group(pattern: .speedTrap, triggers: triggers, index: 0)
    }
    
    private func newTunnelPattern() -> Group {
        let left: [TriggerType]   = [.barrier(Barrier(gates: [.open, .closed, .closed]))]
        let center: [TriggerType] = [.barrier(Barrier(gates: [.closed, .open, .closed]))]
        let right: [TriggerType]  = [.barrier(Barrier(gates: [.closed, .closed, .open]))]
        
        let triggers = [left, left, center, center, right, right, left, center]
        return Group(pattern: .tunnel, triggers: triggers, index: 0)
    }
    
    private func newBarragePattern() -> Group {
        var triggers = [[TriggerType]]()
        for _ in 1...10 { // @HARDCODED
            triggers.append([generateRandomBarrier()])
        }
        
        return Group(pattern: .barrage, triggers: triggers, index: 0)
    }
    
    private func newPacerPattern() -> Group {
        var triggers = [[TriggerType]]()
        for _ in 1...10 { // @HARDCODED
            let random = Double.random()
            if random < 0.075 {
                triggers.append([.empty])
            } else if random < 0.8 {
                triggers.append([generateRandomBarrier()])
            } else {
                triggers.append([generateRandomModifierRow()])
            }
        }
        
        return Group(pattern: .barrage, triggers: triggers, index: 0)
    }
    
    func generateRandomModifierRow() -> TriggerType {
        let randomIndex = Int.random(min: 0, max: 2)
        var modifiers = [ModifierType](repeating: .none, count: 3)
        modifiers[randomIndex] = Double.random() < 0.5 ? .speedUp : .speedDown
        return .modifier(ModifierRow(modifiers: modifiers))
    }
    
    func generateRandomBarrier() -> TriggerType {
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
        
        return .barrier(Barrier(gates: gates))
    }
    
    private func randomGate() -> Gate {
        if Double.random() > 0.5 {
            return .open
        } else {
            return .closed
        }
    }
}
