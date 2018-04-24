//
//  Entity.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// MARK: Entity

struct Entity {
    var id: Int
    var position: Double
    var state: EntityState
    var type: EntityType
    var data: EntityData
}

extension Entity: Equatable {
    static func ==(lhs: Entity, rhs: Entity) -> Bool {
        return
            (lhs.id == rhs.id) &&
            (lhs.position == rhs.position) &&
            (lhs.state == rhs.state) &&
            (lhs.type == rhs.type) &&
            (lhs.data == rhs.data)
    }
}

extension Entity {
    func isA(_ type: EntityType) -> Bool {
        return self.type == type
    }
    
    func thresholdType() -> Threshold? {
        switch self.data {
        case .threshold(let type): return type
        default: return nil
        }
    }
    
    func orbData() -> [Orb]? {
        switch self.data {
        case .orb(let orbs): return orbs
        default: return nil
        }
    }
    
    func barrierData() -> [Gate]? {
        switch self.data {
        case .barrier(let gates): return gates
        default: return nil
        }
    }
    
    func areaData() -> [Area]? {
        switch self.data {
        case .area(let areas): return areas
        default: return nil
        }
    }
}

enum EntityType {
    case none
    case threshold
    case barrier
    case area
    case orb
}

enum EntityData {
    case none
    case threshold(Threshold)
    case barrier([Gate])
    case area([Area])
    case orb([Orb])
}

extension EntityData: Equatable {
    static func ==(lhs: EntityData, rhs: EntityData) -> Bool {
        switch (lhs, rhs) {
            
        case (.none, .none): return true
            
        case let (.threshold(lThreshold), .threshold(rThreshold)):
            return lThreshold == rThreshold
            
        case let (.barrier(lGates), .barrier(rGates)):
            return lGates == rGates
            
        case let (.area(lArea), .area(rArea)):
            return lArea == rArea
            
        case let (.orb(lOrb), .orb(rOrb)):
            return lOrb == rOrb
            
        default: return false
        }
    }
}

// @TODO: Revise these states
enum EntityState {
    case none
    case hit
    case passed
    case over
}

// MARK: Threshold

enum Threshold {
    case normal // @TEMP
    case speed
    case roundOver // @TEMP
}

// MARK: Barrier

enum Gate {
    case open
    case closed
}

// MARK: Area

enum Area {
    case none
    case bad    // @RENAME
    case good   // @RENAME
}

// MARK: Orbs

enum Orb {
    case none
    case speedUp
    case staminaUp
}