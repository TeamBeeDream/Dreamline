//
//  TimeMutatoer.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class TimeMutator: Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent) {
        switch event {
        case .timeUpdate(let deltaTime,
                         let frameNumber,
                         let timeSinceBeginning):
            state.time.deltaTime = deltaTime
            state.time.frameNumber = frameNumber
            state.time.timeSinceBeginning = timeSinceBeginning
        case .timePauseUpdate(let pause):
            state.time.paused = pause
        default: break
        }
    }
}
