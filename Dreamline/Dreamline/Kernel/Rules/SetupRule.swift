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
                .timePauseUpdate(pause: false),
                .healthHitPointSet(3),
                .healthReset,
                .flowControlPhaseUpdate(phase: .select)]
        case .begin:
            self.eventFlag = false
            let chunks = self.sequencer.getChunks(level: state.chunk.level)
            return [
                .boardReset,
                .chunkSet(chunks: chunks),
                .healthInvincibleUpdate(invincible: false)]
        case .play:
            return [.boardScrollSpeedUpdate(speed: state.chunk.current!.speed)]
        case .results:
            if !self.eventFlag {
                self.eventFlag = true
                return [.roundOver(didWin: state.health.hitPoints != 0,
                                   level: state.chunk.level,
                                   score: state.health.barriersPassed),
                        .positionTargetUpdate(target: 0),
                        .chunkLevelUpdate(level: state.chunk.level + 1)]    // @TEMP
            } else {
                return []
            }
        case .select:
            return []
        }
    }
}
