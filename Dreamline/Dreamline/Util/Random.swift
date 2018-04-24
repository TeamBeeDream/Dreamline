//
//  Ranom.swift
//  Dreamline
//
//  Created by BeeDream on 3/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Random {
    func next() -> Double // [0, 1]
    func nextInt(min: Int, max: Int) -> Int // [min, max]
    func nextBool() -> Bool // False, True
}

class MockConstantRandom: Random {
    
    // MARK: Init
    
    static func make() -> MockConstantRandom {
        return MockConstantRandom()
    }
    
    // MARK: Random Methods
    
    func next() -> Double {
        return Double(0.5) // return midvalue
    }
    
    func nextInt(min: Int, max: Int) -> Int {
        let range = Double(max - min)
        let randValue = self.next()
        return Int(randValue * range + Double(min))
    }
    
    func nextBool() -> Bool {
        return true
    }
}

class MockAuthoredRandom: Random {
    
    // MARK: Private Properties
    
    var sequence: [Double]!
    
    // MARK: Init
    
    static func make(sequence: [Double]) -> MockAuthoredRandom {
        let random = MockAuthoredRandom()
        random.sequence = sequence
        return random
    }
    
    // MARK: Random Methods
    
    func next() -> Double {
        assert(!sequence.isEmpty)
        let next = sequence[0]
        sequence.remove(at: 0)
        return next
    }
    
    func nextInt(min: Int, max: Int) -> Int {
        let range = Double(max - min)
        let randValue = self.next()
        return Int(randValue * range + Double(min))
    }
    
    func nextBool() -> Bool {
        return true
    }
}

class RealRandom: Random {
    
    // MARK: Random Methods
    
    func next() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    func nextInt(min: Int, max: Int) -> Int {
        let range = Double(max - min)
        let randValue = self.next()
        return Int(randValue * range + Double(min))
    }
    
    func nextBool() -> Bool {
        return self.next() > 0.5
    }
}
