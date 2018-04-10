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
