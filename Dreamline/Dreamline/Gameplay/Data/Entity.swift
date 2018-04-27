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
    
    func barrierData() -> [Gate]? {
        switch self.data {
        case .barrier(let gates): return gates
        default: return nil
        }
    }
}

enum EntityType {
    case blank
    case threshold
    case barrier
    case area
    case orb
}

enum EntityData {
    case blank
    case threshold(Threshold)
    case barrier([Gate])
}

extension EntityData: Equatable {
    static func ==(lhs: EntityData, rhs: EntityData) -> Bool {
        switch (lhs, rhs) {
            
        case (.blank, .blank): return true
            
        case let (.threshold(lThreshold), .threshold(rThreshold)):
            return lThreshold == rThreshold
            
        case let (.barrier(lGates), .barrier(rGates)):
            return lGates == rGates
            
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
    case roundEnd
    case chunkEnd
}

// MARK: Barrier

enum Gate {
    case open
    case closed
}
