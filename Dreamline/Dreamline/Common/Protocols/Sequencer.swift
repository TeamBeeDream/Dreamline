//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

/**
 Generates a sequence of entities
 */
protocol Sequencer {
    func getNextEntity(config: GameConfig) -> [EntityData]
}

// @NOTE: This is a temporary solution
//        It's really only meant for testing before
//        the AuthoredSequencer is complete
class RandomSequencer: Sequencer {
    func getNextEntity(config: GameConfig) -> [EntityData] {
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

// @TODO: Make more dynamic
//        Right now the results of this sequencer are predictable
// @NOTE: This is sequencer experienced by the player
class AuthoredSequencer: Sequencer {
    private var queue = [Group]()
    
    init() {
        // Always do the same thing at the beginning
        queue.append(self.newGapPattern(count: 3))
        queue.append(self.newStartPattern())
        queue.append(self.newGapPattern(count: 1))
        queue.append(self.newBoostPattern())
    }
    
    func getNextEntity(config: GameConfig) -> [EntityData] {
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
        
        // Pull next entity from queue
        var originalGroup = queue.removeFirst()
        var updatedGroup = originalGroup.clone()
        let nextEntity = originalGroup.entities[originalGroup.index]
        
        // if group still has triggers
        if originalGroup.index + 1 < originalGroup.entities.count {
            updatedGroup.index += 1
            queue.insert(updatedGroup, at: 0)
        }
        
        return nextEntity
    }
    
    private func newStartPattern() -> Group {
        let barrier: [EntityData] = [.barrier(Barrier(gates: [.closed, .open, .closed]))]
        let entities = [[EntityData]](repeating: barrier, count: 3)
        return Group(pattern: .start, entities: entities, index: 0)
    }
    
    private func newGapPattern(count: Int) -> Group {
        let emptyEntity: [EntityData] = [.empty]
        let entities = [[EntityData]](repeating: emptyEntity, count: count)
        return Group(pattern: .gap, entities: entities, index: 0)
    }
    
    private func newBoostPattern() -> Group {
        let leftBoost: [EntityData] = [.modifier(ModifierRow(modifiers: [.speedUp, .none, .none]))]
        let rightBoost: [EntityData] = [.modifier(ModifierRow(modifiers: [.none, .none, .speedUp]))]
        
        let entities = [leftBoost, rightBoost, leftBoost] // @TODO: Chirality support
        return Group(pattern: .boost, entities: entities, index: 0)
    }
    
    private func newSpeedTrapPattern() -> Group {
        let barrier: EntityData = .barrier(Barrier(gates: [.closed, .open, .closed]))
        let modifier: EntityData = .modifier(ModifierRow(modifiers: [.none, .speedUp, .none]))
        
        let entities = [[barrier, modifier]]
        return Group(pattern: .speedTrap, entities: entities, index: 0)
    }
    
    private func newTunnelPattern() -> Group {
        let left: [EntityData]   = [.barrier(Barrier(gates: [.open, .closed, .closed]))]
        let center: [EntityData] = [.barrier(Barrier(gates: [.closed, .open, .closed]))]
        let right: [EntityData]  = [.barrier(Barrier(gates: [.closed, .closed, .open]))]
        
        let entities = [left, left, center, center, right, right, left, center]
        return Group(pattern: .tunnel, entities: entities, index: 0)
    }
    
    private func newBarragePattern() -> Group {
        var entities = [[EntityData]]()
        for _ in 1...10 { // @HARDCODED
            entities.append([generateRandomBarrier()])
        }
        
        return Group(pattern: .barrage, entities: entities, index: 0)
    }
    
    private func newPacerPattern() -> Group {
        var entities = [[EntityData]]()
        for _ in 1...10 { // @HARDCODED
            let random = Double.random()
            if random < 0.075 {
                entities.append([.empty])
            } else if random < 0.8 {
                entities.append([generateRandomBarrier()])
            } else {
                entities.append([generateRandomModifierRow()])
            }
        }
        
        return Group(pattern: .barrage, entities: entities, index: 0)
    }
    
    func generateRandomModifierRow() -> EntityData {
        let randomIndex = Int.random(min: 0, max: 2)
        var modifiers = [ModifierType](repeating: .none, count: 3)
        modifiers[randomIndex] = Double.random() < 0.5 ? .speedUp : .speedDown
        return .modifier(ModifierRow(modifiers: modifiers))
    }
    
    func generateRandomBarrier() -> EntityData {
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

extension AuthoredSequencer {
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
        var entities: [[EntityData]]
        var index: Int
        
        func clone() -> Group {
            return Group(pattern: self.pattern,
                         entities: self.entities,
                         index: self.index)
        }
    }
}
