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
        case .chunkNext:
            if !state.chunk.chunks.isEmpty {
//                state.chunk.current = nil
//            } else {
                state.chunk.current = state.chunk.chunks.removeFirst()
            }
        case .chunkSet(let chunks):
            state.chunk.chunks = chunks
            state.chunk.current = state.chunk.chunks.removeFirst()
        case .multiple(let events):
            for bundledEvent in events {
                self.mutateState(state: &state, event: bundledEvent)
            }
        default: break
        }
    }
}
