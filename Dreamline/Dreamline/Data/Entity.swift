//
//  Entity.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct EntityData {
    var id: Int
    var position: Double
    var state: EntityState
    var type: EntityType
}

enum EntityState {
    case none
    case hit
    case passed
}

enum EntityType {
    case barrier([Bool])
    case threshold
}
