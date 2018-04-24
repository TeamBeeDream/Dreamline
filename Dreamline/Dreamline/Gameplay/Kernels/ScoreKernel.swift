//
//  ScoreKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/23/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class ScoreKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> ScoreKernel {
        let instance = ScoreKernel()
        return instance
    }
    
    // MARK: Kernel Methods
    
    func update(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        switch instr {
        case .addScore(let newPoints):
            state.scoreState.barriersPassed += newPoints
            events.append(.scoreUpdated(state.scoreState.barriersPassed))
            
        case .resetScore:
            state.scoreState.barriersPassed = 0
            events.append(.scoreUpdated(0))
            
        default: break
        }
    }
}
