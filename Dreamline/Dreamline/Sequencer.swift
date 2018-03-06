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

struct PatternSource {
    let patterns: [Int: [Pattern]]
    //let width: Int
}

struct PatternOptions {
    let groupCount: Int
    let groupLength: Int
    //let groupPadding: Int
    let difficulty: Int
}

protocol Sequencer {
    func generatePatterns(source: PatternSource, options: PatternOptions) -> [Pattern]
}

// @TODO: rename class
class DefaultSequencer: Sequencer {
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


// @TODO: move to separate file
class Math {
    static func randInt(min: Int, max: Int) -> Int {
        let range = max - min
        let randValue = Int(arc4random_uniform(UInt32(range)))
        return Int(randValue + min) // @TODO: use call to random()
    }
    
    static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    static func random(min: Double, max: Double) -> Double {
        return random() * (max - min) + min
    }
}
