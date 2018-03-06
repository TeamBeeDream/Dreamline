//
//  Sequencer.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

/*
enum PatternDifficulty {
    case EASY
}
 */

enum Gate {
    case open
    case closed
}

struct Pattern {
    let data: [Gate]    // @TODO: maybe typedef/alias this
}
/*
 @TODO: move into authored sequencer
struct PatternSource {
    let patterns: [Int: [Pattern]]
}
 */

/*
 @TODO: move into authored sequencer
struct PatternOptions {
    let groupCount: Int
    let groupLength: Int
    let difficulty: Int
}
 */

protocol Sequencer {
    func getNextPattern() -> Pattern
    // @TODO: should there be a method like: anyRemaining() -> Bool ?
}

class RandomSequencer: Sequencer {
    func getNextPattern() -> Pattern {
        // generate a random pattern
        var gates = [Gate]()
        for _ in 1...3 {
            gates.append(self.randomGate())
        }
        //print(gates)
        return Pattern(data: gates)
    }
    
    func randomGate() -> Gate {
        if Math.random() > 0.5 {
            return .open
        } else {
            return .closed
        }
    }
}

// @TODO: implement authored sequencer
/*
class AuthoredSequencer: Sequencer {
    func generatePatterns(source: PatternSource, options: PatternOptions) -> [Pattern] {
        var patterns = [Pattern]()
        
        for _ in 0...options.groupCount {
            for _ in 0...options.groupLength {
                patterns.append(self.searchForPattern(source: source, difficulty: options.difficulty))
            }
            /*
            for _ in 0...options.groupPadding {
                patterns.append(self.emptyPattern())
            }
            */
        }
        
        return patterns
    }
    
    // @FIXME: for now, it just returns a random pattern of the correct difficulty
    private func searchForPattern(source: PatternSource, difficulty: Int) -> Pattern {
        assert(source.patterns[difficulty] != nil)
        
        let patterns = source.patterns[difficulty]!
        return patterns[Math.randInt(min: 0, max: patterns.count-1)]
    }
    
    private func emptyPattern() -> Pattern {
        return Pattern(data: [.closed, .closed, .closed])
    }
}
 */



