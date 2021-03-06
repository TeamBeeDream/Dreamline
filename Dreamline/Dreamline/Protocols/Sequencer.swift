//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Sequencer {
    func getNextEntity(config: GameConfig) -> [EntityData]
    // @TODO: How many entities should this spit out at once?
    // rn, it just keeps generating them, but it's hard to manage
    // chunked patterns
    // Also, the config determines the difficulty, should probably be
    // more explicit as to how the difficulty impacts the generated patterns
}

// @TODO: Make more dynamic
//        Right now the results of this sequencer are predictable
// @NOTE: This is sequencer experienced by the player
class DynamicSequencer: Sequencer {
    
    var random: Random!
    
    // MARK: Private Properties
    
    private var queue = [Group]()
    
    // MARK: Init
    
    static func make() -> DynamicSequencer {
        return DynamicSequencer.make(random: RealRandom()) // By default, use real random
    }
    
    static func make(random: Random) -> DynamicSequencer {
        let sequencer = DynamicSequencer()
        sequencer.random = random
        return sequencer
    }
    
    init() {
        // Always do the same thing at the beginning
        self.queueGroup(self.newGapPattern(count: 3))
        self.queueGroup(self.newStartPattern())
    }
    
    // MARK: Sequencer Methods
    
    func getNextEntity(config: GameConfig) -> [EntityData] {
        // @HACK
        let ruleset = RulesetFactory.getDefault()
        let difficulty = ruleset.speedLookup[config.boardScrollSpeed]!.difficulty
        
        if queue.isEmpty {
            // @TODO: Sequence patterns dynamically
            // @HARDCODED
            self.queueGroup(self.newTunnelPattern(difficulty: difficulty, length: 10))
            self.queueGroup(self.newGapPattern(count: 3))
            self.queueGroup(self.newBarragePattern(difficulty: difficulty, length: 10))
            self.queueGroup(self.newGapPattern(count: 3))
            self.queueGroup(self.newPacerPattern(difficulty: difficulty, length: 10))
            self.queueGroup(self.newGapPattern(count: 3))
            
            if config.discreteRounds { // @HACK
                self.queueGroup(self.newThresholdPattern(type: .roundOver))
                self.queueGroup(self.newGapPattern(count: 10))
            } else {
                self.queueGroup(self.newThresholdPattern(type: .speedUp))
                self.queueGroup(self.newGapPattern(count: 5))
            }
        }
        
        // Pull next entity from queue
        var originalGroup = queue.removeFirst()
        var updatedGroup = originalGroup.clone()
        let nextEntity = originalGroup.entities[originalGroup.index]
        
        // If group still has triggers
        if originalGroup.index + 1 < originalGroup.entities.count {
            updatedGroup.index += 1
            queue.insert(updatedGroup, at: 0)
        }
        
        return nextEntity
    }
    
    // MARK: Private Methods
    
    private func queueGroup(_ group: Group) {
        queue.append(group)
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
    
    private func newSpeedTrapPattern() -> Group {
        let barrier: EntityData = .barrier(Barrier(gates: [.closed, .open, .closed]))
        let modifier: EntityData = .modifier(ModifierRow(modifiers: [.none, .speedUp, .none]))
        
        let entities = [[barrier, modifier]]
        return Group(pattern: .speedTrap, entities: entities, index: 0)
    }
    
    private func newTunnelPattern(difficulty: Double, length: Int) -> Group {
        assert(difficulty >= 0.0)
        assert(difficulty <= 1.0)
        
        let left: [EntityData]   = [.barrier(Barrier(gates: [.open, .closed, .closed]))]
        let center: [EntityData] = [.barrier(Barrier(gates: [.closed, .open, .closed]))]
        let right: [EntityData]  = [.barrier(Barrier(gates: [.closed, .closed, .open]))]
        
        var entities = [[EntityData]]()
        for _ in 1...length {
            // @HACK: What this does is pick a random number, and if
            // that number is greater than the given difficulty,
            // it will then randomly pick either left or right
            // otherwise it will return center
            let randomValue = self.random.next()
            if randomValue > difficulty {
                entities.append(center)
            } else {
                let side = self.random.next()
                if side > 0.5 { entities.append(left) }
                else { entities.append(right) }
            }
        }
        
        return Group(pattern: .tunnel,
                     entities: entities,
                     index: 0)
    }
    
    private func newBarragePattern(difficulty: Double, length: Int) -> Group {
        assert(difficulty >= 0.0)
        assert(difficulty <= 1.0)
        
        var entities = [[EntityData]]()
        for _ in 1...length {
            entities.append([generateRandomBarrier(difficulty: difficulty)])
        }
        
        return Group(pattern: .barrage, entities: entities, index: 0)
    }
    
    private func newPacerPattern(difficulty: Double, length: Int) -> Group {
        assert(difficulty >= 0.0)
        assert(difficulty <= 1.0)
        
        var entities = [[EntityData]]()
        for _ in 1...length {
            let random = self.random.next()
            if random < 0.2 {
                entities.append([.empty])
            } else {
                entities.append([generateRandomBarrier(difficulty: difficulty)])
            }
        }
        
        return Group(pattern: .barrage, entities: entities, index: 0)
    }
    
    private func newThresholdPattern(type: ThresholdType) -> Group {
        let threshold = [EntityData.threshold(type)]
        let entities = [threshold]
        return Group(pattern: .threshold, entities: entities, index: 0)
    }
    
    private func generateRandomBarrier(difficulty: Double) -> EntityData {
        assert(difficulty >= 0.0)
        assert(difficulty <= 1.0)
        
        var gates = [Gate]()
        
        // @HACK: This either only opens a single gate
        // or it opens both the left or right.
        let randomValue = self.random.next()
        if randomValue < difficulty {
            let rPos = self.random.next()
            if rPos < 0.33 {
                gates.append(.open)
                gates.append(.closed)
                gates.append(.closed)
            } else if rPos < 0.66 {
                gates.append(.closed)
                gates.append(.open)
                gates.append(.closed)
            } else {
                gates.append(.closed)
                gates.append(.closed)
                gates.append(.open)
            }
        } else {
            
            gates.append(.open)
            gates.append(.closed)
            gates.append(.open)
        }
        
        return .barrier(Barrier(gates: gates))
    }
    
    private func randomGate() -> Gate {
        if self.random.next() > 0.5 {
            return .open
        } else {
            return .closed
        }
    }
}

extension DynamicSequencer {
    private enum Pattern {
        case start          // intro at the beginning of every round
        case boost          // at the beginning, gives you choice to speed up right away
        case speedTrap      // a trigger that forces you to change speed
        case tunnel         // a set of barriers that only have one open gate each
        case barrage        // a random set of barriers, difficult to get through
        case pacer          // a random set of barriers, majority of patterns
        case gap            // a gap consisting of empty triggers
        case threshold      // a threshold
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
