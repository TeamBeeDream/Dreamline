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
    private var barrierCrossSound: SKAudioNode!
    private var barrierPassSound: SKAudioNode!
    private var playerAwaySound: SKAudioNode!
    private var playerBackSound: SKAudioNode!
    private var thresholdChunkSound: SKAudioNode!
    private var thresholdRoundSound: SKAudioNode!
    
    private var lane: Int = 0
    
    static func make(scene: SKScene) -> AudioRenderer {
        let instance = AudioRenderer()
        instance.scene = scene
        instance.addBackgroundMusic()
        instance.addSounds()
        return instance
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .settingsMuteUpdate(let mute):
            self.handleMuteUpdate(mute: mute)
        case .positionTargetUpdate(let target):
            if lane != target {
                if target == 0 {
                    self.playerBackSound.run(SKAction.play())
                } else {
                    self.playerAwaySound.run(SKAction.play())
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
    
    private func addSounds() {
        self.barrierPassSound = Resources.shared.getSound(.barrierPass)
        self.scene.addChild(self.barrierPassSound)
        
        self.barrierCrossSound = Resources.shared.getSound(.barrierCross)
        self.scene.addChild(self.barrierCrossSound)
        
        self.thresholdChunkSound = Resources.shared.getSound(.thresholdChunkCross)
        self.scene.addChild(self.thresholdChunkSound)
        
        self.thresholdRoundSound = Resources.shared.getSound(.thresholdRoundCross)
        self.scene.addChild(self.thresholdRoundSound)
        
        self.playerAwaySound = Resources.shared.getSound(.playerMoveAway)
        self.scene.addChild(self.playerAwaySound)
        
        self.playerBackSound = Resources.shared.getSound(.playerMoveBack)
        self.scene.addChild(self.playerBackSound)
    }

    private func handleEvent(type: EntityType, state: EntityState) {
        switch type {
        case .threshold(let type):
            switch type {
            case .chunkEnd:
                self.thresholdChunkSound.run(SKAction.play())
            case .roundEnd:
                self.thresholdRoundSound.run(SKAction.play())
            }
        case .barrier:
            if state == .crossed {
                self.barrierCrossSound.run(SKAction.play())
            }
            if state == .passed {
                self.barrierPassSound.run(SKAction.play())
            }
        default:
            break
        }
    }
    
    private func handleMuteUpdate(mute: Bool) {
        let volume = Float(mute ? 0.0 : 1.0)
        self.backgroundMusic.run(SKAction.changeVolume(to: volume, duration: 0.5))
    }
}
