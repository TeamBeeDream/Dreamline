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
            return [
                .healthHitPointSet(3),
                .chunkLevelUpdate(level: 0), // @FIXME
                .flowControlPhaseUpdate(phase: .begin)]
        case .begin:
            self.eventFlag = false
            let chunks = self.sequencer.getChunks(level: state.chunk.level)
            return [
                .timePauseUpdate(pause: false),
                .boardReset,
                .boardScrollSpeedUpdate(speed: state.board.scrollSpeed), // @TODO
                .chunkSet(chunks: chunks),
                .healthInvincibleUpdate(invincible: false),
                .flowControlPhaseUpdate(phase: .play)]
        case .results:
            if !self.eventFlag {
                self.eventFlag = true
                return [.roundOver(didWin: state.health.hitPoints != 0,
                                   level: state.chunk.level,
                                   score: state.health.barriersPassed),
                        .chunkLevelUpdate(level: state.chunk.level + 1)]    // @TEMP
            } else {
                return []
            }
        default:
            return []
        }
    }
}
