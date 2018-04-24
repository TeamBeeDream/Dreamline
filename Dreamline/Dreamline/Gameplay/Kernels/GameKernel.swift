//
//  GameKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/24/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @NOTE: Need a better solution for handling state changes in the game.
class GameKernel: Kernel {
    
    static func make() -> GameKernel {
        return GameKernel()
    }
    
    func update(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        switch instr {
            
        case .roundComplete:
            events.append(.roundComplete(state.scoreState))
            
        default: break
        }
    }
}
