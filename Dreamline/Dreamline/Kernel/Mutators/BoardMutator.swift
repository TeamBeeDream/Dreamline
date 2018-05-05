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
        case .boardEntityStateUpdate(let id, _, let entityState):
            let index = state.board.entities.index(where: { $0.id == id })!
            var entity = state.board.entities.remove(at: index)
            entity.state = entityState // @HACK
            state.board.entities.insert(entity, at: index)
        case .boardScrollSpeedUpdate(let speed):
            state.board.scrollSpeed = speed
        case .boardReset:
            state.board.lastEntityPosition = 0.0
            state.board.position = 0.0
        default: break
        }
    }
}
