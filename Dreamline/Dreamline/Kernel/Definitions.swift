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
}

protocol Rule {
    func process(state: KernelState) -> KernelEvent?
}

protocol Mutator {
    func mutateState(state: inout KernelState)
}

enum KernelEvent {
    case timeUpdate(deltaTime: Double,
                    frameNumber: Int,
                    timeSinceBeginning: Double)
}
