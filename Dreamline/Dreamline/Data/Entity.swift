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

extension Entity {
    func isThreshold() -> Bool {
        return self.type == .threshold
    }
    
    func isBarrier() -> Bool {
        return self.type == .barrier
    }
    
    func isArea() -> Bool {
        return self.type == .area
    }
    
    func thresholdType() -> ThresholdType? {
        switch self.data {
        case .threshold(let type):
            return type
        default:
            return nil
        }
    }
}

enum EntityType {
    case threshold
    case barrier
    case area
}

enum EntityData {
    case threshold(ThresholdType)
    case barrier([Gate])
    case area([Area])
}

// @TODO: Revise these states
enum EntityState {
    case none
    case hit
    case passed
    case over
}

// MARK: Threshold

enum ThresholdType {
    case normal // @TEMP
    case speed
}

// MARK: Barrier

enum Gate {
    case open
    case closed
}

// MARK: Area

enum Area {
    case active
    case inactive
}
