//
//  FlowControlMutator.swift
//  Dreamline
//
//  Created by BeeDream on 4/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class FlowControlMutator: Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent) {
        switch event {
        case .flowControlPhaseUpdate(let phase):
            state.flowControl.phase = phase
        case .multiple(let events):
            for bundledEvent in events {
                self.mutateState(state: &state, event: bundledEvent)
            }
        default: break
        }
    }
}
