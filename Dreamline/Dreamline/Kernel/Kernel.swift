//
//  Kernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Kernel {
    func update(deltaTime: Double) -> [KernelEvent]
}

class MasterKernel: Kernel {
    func update(deltaTime: Double) -> [KernelEvent] {
        return []
    }
}
