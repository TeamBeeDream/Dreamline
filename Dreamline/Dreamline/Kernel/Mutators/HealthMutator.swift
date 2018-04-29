//
//  HealthMutator.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class HealthMutator: Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent) {
        switch event {
        case .healthHitPointSet(let hp):
            state.health.hitPoints = hp
        case .healthHitPointUpdate(let increment):
            state.health.hitPoints += increment
        case .healthInvincibleUpdate(let invincible):
            state.health.invincible = invincible
        case .multiple(let events):
            for bundledEvent in events {
                self.mutateState(state: &state, event: bundledEvent)
            }
        default: break
        }
    }
    
    private func getInvincible(type: EntityType, state: EntityState) -> Bool {
        switch type {
        case .barrier:
            return state == .crossed
        case .threshold(let type):
            return type != .chunkEnd
        case .blank:
            assert(false)
        }
    }
}
