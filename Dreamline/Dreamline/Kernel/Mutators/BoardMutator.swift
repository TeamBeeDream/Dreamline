//
//  BoardMutator.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class BoardMutator: Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent) {
        switch event {
        case .boardScroll(let distance):
            state.board.position += distance
            for (i, _) in state.board.entities.enumerated() {
                state.board.entities[i].position += distance
            }
        case .boardEntityAdd(let entity):
            state.board.entities.append(entity)
            state.board.lastEntityPosition = state.board.position
        case .boardEntityRemove(let id):
            let index = state.board.entities.index(where: { $0.id == id })! // @HACK
            state.board.entities.remove(at: index)
        case .multiple(let events):
            for bundledEvent in events {
                self.mutateState(state: &state, event: bundledEvent)
            }
        default: break
        }
    }
}
