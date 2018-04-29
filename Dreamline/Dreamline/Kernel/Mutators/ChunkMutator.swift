//
//  ChunkMutator.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class ChunkMutator: Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent) {
        switch event {
        case .chunkUpdate(let type, let difficulty, let length):
            state.chunk.type = type
            state.chunk.difficuly = difficulty
            state.chunk.length = length
        case .multiple(let events):
            for bundledEvent in events {
                self.mutateState(state: &state, event: bundledEvent)
            }
        default: break
        }
    }
}
