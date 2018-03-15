//
//  BoardState.swift
//  Dreamline
//
//  Created by BeeDream on 3/14/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @CLEANUP: Move this somewhere better
// Should this have all of the data?
enum ScrollSpeed: Int {
    case mach1 = 0
    case mach2 = 1
    case mach3 = 2
    case mach4 = 3
    case mach5 = 4
}

// @RENAME: this is more than just the type, it IS the data
enum TriggerType {
    case barrier(Barrier)
    case modifier(ModifierRow)
    case empty // not sure if this is a good idea
}

// @RENAME: this is close
// name needs to imply that it's a line that you cross
// and when you cross it, it changes something about the state
struct Trigger {
    let id: Int
    var position: Double
    var status: TriggerStatus
    var type: TriggerType
}

extension Trigger {
    func clone() -> Trigger {
        return Trigger(id: self.id,
                       position: self.position,
                       status: self.status,
                       type: self.type)
    }
}

enum TriggerStatus {
    case idle // @RENAME
    case pass
    case hit
}

struct Barrier {
    let gates: [Gate] // only this left, huh
}

enum ModifierType {
    case speedUp
    case speedDown
    case none // this is a little weird
}

struct ModifierRow {
    let modifiers: [ModifierType]
}

extension Barrier {
    func clone() -> Barrier {
        return Barrier(gates: self.gates)
    }
}

struct BoardLayout {
    var spawnPosition: Double
    var destroyPosition: Double
    var playerPosition: Double
    var laneOffset: Double
}

struct BoardState {
    var triggers: [Trigger]
    var totalDistance: Double
    var distanceSinceLastTrigger: Double
    var totalTriggerCount: Int // @CLEANUP: this is used for assigning unique int ids
    var layout: BoardLayout
    
    init(layout: BoardLayout) {
        self.triggers = [Trigger]()
        self.totalDistance = 0.0
        self.distanceSinceLastTrigger = 0.0
        self.totalTriggerCount = 0
        // @FIXME: This feels buggy, what should the default layout be?
        self.layout = layout
    }
}

// @CLEANUP, should probably use factory method
extension BoardState {
    private init(triggers: [Trigger],
                 totalDistance: Double,
                 totalTriggerCount: Int,
                 distanceSinceLastTrigger: Double,
                 layout: BoardLayout) {
        
        self.triggers = triggers
        self.totalDistance = totalDistance
        self.totalTriggerCount = totalTriggerCount
        self.distanceSinceLastTrigger = distanceSinceLastTrigger
        self.layout = layout
    }
    
    func clone() -> BoardState {
        return BoardState(triggers: self.triggers,
                          totalDistance: self.totalDistance,
                          totalTriggerCount: self.totalTriggerCount,
                          distanceSinceLastTrigger: self.distanceSinceLastTrigger,
                          layout: self.layout)
    }
}
