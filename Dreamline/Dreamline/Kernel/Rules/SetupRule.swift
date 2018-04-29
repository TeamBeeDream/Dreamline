//
//  SetupRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SetupRule: Rule {
    
    private var chunkSequencer = ChunkSequencer()
    
    func process(state: KernelState, deltaTime: Double) -> KernelEvent? {
        if state.flowControl.phase == .origin {
            let chunks = self.chunkSequencer.getChunks(start: 0.2, end: 1.0, variation: 0.1, count: 5)
            return .multiple(events: [
                .flowControlPhaseUpdate(phase: .begin),
                .chunkSet(chunks: chunks),
                .healthHitPointSet(3),
                .healthInvincibleUpdate(invincible: false),
                .timePauseUpdate(pause: false)])
        }
        
        // @TEMP
        if state.flowControl.phase == .begin {
            return .flowControlPhaseUpdate(phase: .play)
        }
        
        return nil
    }
}
