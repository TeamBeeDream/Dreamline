//
//  Entity.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

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

enum EntityState {
    case none
    case hit // ?
    case passed
    case over // ?
}

enum EntityData {
    case threshold
    case barrier([Bool])
    case area([Bool])
}
