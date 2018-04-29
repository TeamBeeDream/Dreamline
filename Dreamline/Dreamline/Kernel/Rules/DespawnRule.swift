//
//  CleanupRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class DespawnRule: Rule {
    func process(state: KernelState, deltaTime: Double) -> KernelEvent? {
        for entity in state.board.entities {
            if entity.position > state.board.layout.upperBound {
                return .boardEntityRemove(id: entity.id)
            }
        }
        
        return nil
    }
}
