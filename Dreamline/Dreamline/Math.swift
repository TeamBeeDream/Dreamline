//
//  Math.swift
//  Dreamline
//
//  Created by BeeDream on 3/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @TODO: maybe add Lerp code to this class
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
