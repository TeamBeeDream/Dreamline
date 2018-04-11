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
    func isA(_ type: EntityType) -> Bool {
        return self.type == type
    }
    
    func thresholdType() -> ThresholdType? {
        switch self.data {
        case .threshold(let type):
            return type
        default:
            return nil
        }
    }
    
    func orbData() -> [Orb]? {
        switch self.data {
        case .orb(let orbs):
            return orbs
        default:
            return nil
        }
    }
}

enum EntityType {
    case threshold
    case barrier
    case area
    case orb
}

enum EntityData {
    case threshold(ThresholdType)
    case barrier([Gate])
    case area([Area])
    case orb([Orb])
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
