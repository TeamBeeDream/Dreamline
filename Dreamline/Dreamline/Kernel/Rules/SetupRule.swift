//
//  SetupRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SetupRule: Rule {
    
    //private var sequencer: ChunkSequencer = DebugChunkSequencer() // @TEMP
    private var sequencer = MasterChunkSequencer()
    
    func process(state: KernelState, deltaTime: Double) -> KernelEvent? {
        if state.flowControl.phase == .origin {
            let chunks = self.sequencer.getChunks(level: state.chunk.level)
            return .multiple(events: [
                .flowControlPhaseUpdate(phase: .begin),
                .chunkSet(chunks: chunks),
                .chunkLevelUpdate(level: state.chunk.level + 1),    // @TEMP
                .boardScrollSpeedUpdate(speed: state.board.scrollSpeed * 1.1), // @TEMP
                .healthHitPointSet(3),
                .healthInvincibleUpdate(invincible: false),
                .timePauseUpdate(pause: false),
                .boardReset])
        }
        
        // @TEMP
        if state.flowControl.phase == .begin {
            return .flowControlPhaseUpdate(phase: .play)
        }
        
        return nil
    }
}
