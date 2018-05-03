//
//  SetupRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SetupRule: Rule {
    
    private var sequencer = MasterChunkSequencer()
    private var eventFlag: Bool = false
    
    func process(state: KernelState, deltaTime: Double) -> [KernelEvent] {
        switch state.flowControl.phase {
        case .origin:
            let chunks = self.sequencer.getChunks(level: state.chunk.level)
            return [.flowControlPhaseUpdate(phase: .begin),
                    .chunkSet(chunks: chunks),
                    .boardScrollSpeedUpdate(speed: state.board.scrollSpeed * 1.1), // @TEMP
                    .healthReset,
                    .healthInvincibleUpdate(invincible: false),
                    .timePauseUpdate(pause: false),
                    .boardReset]
        case .begin:
            self.eventFlag = false
            return [.flowControlPhaseUpdate(phase: .play)]
        case .results:
            if !self.eventFlag {
                self.eventFlag = true
                return [.roundOver(didWin: state.health.hitPoints != 0,
                                   level: state.chunk.level,
                                   accuracy: Double(state.health.barriersPassed) / Double(state.health.totalBarriers)),
                        .chunkLevelUpdate(level: state.chunk.level + 1)]    // @TEMP
            } else {
                return []
            }
        default:
            return []
        }
    }
}
