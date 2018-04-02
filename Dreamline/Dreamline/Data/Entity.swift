//
//  Entity.swift
//  Dreamline
//
//  Created by BeeDream on 3/19/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// MARK: Entity

/**
 An Entity is an object that exists
 on the board and scrolls with it
 */
struct Entity {
    let id: Int
    var position: Double
    var status: EntityStatus
    var data: EntityData
}

enum EntityData {
    case barrier(Barrier)
    case modifier(ModifierRow)
    case threshold
    case empty
}

enum EntityStatus {
    case active
    case pass
    case hit
}

extension Entity {
    func clone() -> Entity {
        return Entity(id: self.id,
                      position: self.position,
                      status: self.status,
                      data: self.data)
    }
}

// MARK: Barrier

struct Barrier {
    let gates: [Gate]
}

extension Barrier {
    func clone() -> Barrier {
        return Barrier(gates: self.gates)
    }
}

enum Gate {
    case open
    case closed
}

// MARK: Modifiers

struct ModifierRow {
    let modifiers: [ModifierType]
}

enum ModifierType {
    case speedUp
    case speedDown
    case none
}


