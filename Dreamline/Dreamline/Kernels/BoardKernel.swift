//
//  BoardKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class BoardKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> BoardKernel {
        let instance = BoardKernel()
        return instance
    }
    
    // MARK: Kernel Methods
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        
        switch instr {
        
        case .addEntity(let data):
            state.boardState.entities[data.id] = data
            events.append(.entityAdded(data))
        
        case .removeEntity(let id):
            state.boardState.entities[id] = nil
            events.append(.entityRemoved(id))
            
        case .scrollBoard(let distance):
            for id in state.boardState.entities.keys {
                state.boardState.entities[id]!.position += distance
            }
            state.boardState.scrollDistance += distance
            events.append(.boardScrolled(distance))
            
        case .makeEntityActive(let id):
            state.boardState.entities[id]!.active = true
            events.append(.entityMarkedActive(id))
            
        case .makeEntityInactive(let id):
            state.boardState.entities[id]!.active = false
            events.append(.entityMarkedInactive(id))
            
        default: break
            
        }
    }
}
















