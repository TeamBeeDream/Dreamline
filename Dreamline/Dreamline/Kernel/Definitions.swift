//
//  Definitions.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Kernel {
    func update(deltaTime: Double) -> [KernelEvent]
    func getState() -> KernelState
}

protocol Rule {
    func process(state: KernelState, deltaTime: Double) -> KernelEvent?
}

protocol Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent)
}

enum KernelEvent {
    case timeUpdate(deltaTime: Double,
                    frameNumber: Int,
                    timeSinceBeginning: Double)
    case boardScroll(distance: Double)
    case boardAddEntity(entity: Entity)
}
