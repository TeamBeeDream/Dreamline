//
//  AudioRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import AVFoundation

class AudioRenderer: Observer {
    
    private var scene: SKScene!
    private var backgroundMusic: SKAudioNode!
    
    private var lane: Int = 0
    
    static func make(scene: SKScene) -> AudioRenderer {
        let instance = AudioRenderer()
        instance.scene = scene
        instance.addBackgroundMusic()
        return instance
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .settingsMuteUpdate(let mute):
            self.handleMuteUpdate(mute: mute)
        case .positionTargetUpdate(let target):
            if lane != target {
                if target == 0 {
                    self.playSound(Resources.shared.getSound(.playerMoveBack))
                } else {
                    self.playSound(Resources.shared.getSound(.playerMoveAway))
                }
            }
            self.lane = target
        case .boardEntityStateUpdate(_, let type, let state):
            self.handleEvent(type: type, state: state)
        default: break
        }
    }
    
    private func addBackgroundMusic() {
        self.backgroundMusic = Resources.shared.getMusic(.main)
        self.backgroundMusic.autoplayLooped = true
        self.scene.addChild(self.backgroundMusic)
    }

    private func handleEvent(type: EntityType, state: EntityState) {
        switch type {
        case .threshold(let type):
            switch type {
            case .chunkEnd:
                self.playSound(Resources.shared.getSound(.thresholdChunkCross))
            case .roundEnd:
                self.playSound(Resources.shared.getSound(.thresholdRoundCross))
            }
        case .barrier:
            if state == .crossed {
                self.playSound(Resources.shared.getSound(.barrierCross))
            }
            if state == .passed {
                self.playSound(Resources.shared.getSound(.barrierPass))
            }
        default:
            break
        }
    }
    
    private func handleMuteUpdate(mute: Bool) {
        let volume = Float(mute ? 0.0 : 1.0)
        self.backgroundMusic.run(SKAction.changeVolume(to: volume, duration: 0.5))
    }
    
    private func playSound(_ player: SKAction) {
        self.scene.run(player)
    }
}
