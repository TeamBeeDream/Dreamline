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
    private var nullNode: SKNode!
    private var backgroundMusic: SKAudioNode!
    private var barrierCross: SKAction!
    private var thresholdCross: SKAction!
    
    static func make(scene: SKScene) -> AudioRenderer {
        let instance = AudioRenderer()
        instance.scene = scene
        instance.preloadAudio()
        return instance
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .settingsMuteUpdate(let mute):
            self.handleMuteUpdate(mute: mute)
        case .boardEntityStateUpdate(_, let type, let state):
            self.handleEvent(type: type, state: state)
        case .multiple(let events):
            for e in events { self.observe(event: e) }
        default: break
        }
    }
    
    private func preloadAudio() {
        self.addBackgroundMusic()
        self.loadSoundEffects()
    }
    
    private func addBackgroundMusic() {
        let musicUrl = Bundle.main.url(forResource: "Dreamline_cloud_theme", withExtension: "mp3")
        self.backgroundMusic = SKAudioNode(url: musicUrl!)
        self.backgroundMusic.autoplayLooped = true
        self.backgroundMusic.run(SKAction.changeVolume(to: 0.0, duration: 0.0)) // @TEMP
        self.backgroundMusic.run(SKAction.changeVolume(to: 1.0, duration: 1.0)) // @TEMP
        self.scene.addChild(self.backgroundMusic)
    }
    
    private func loadSoundEffects() {
        self.nullNode = SKNode()
        self.nullNode.run(SKAction.changeVolume(to: 0.0, duration: 0.0))
        self.scene.addChild(self.nullNode)
        self.barrierCross = SKAction.playSoundFileNamed("barrier_cross_quiet.mp3", waitForCompletion: false)
        self.thresholdCross = SKAction.playSoundFileNamed("threshold_cross.mp3", waitForCompletion: false)
    }

    private func handleEvent(type: EntityType, state: EntityState) {
        switch type {
        case .threshold(let type):
            switch type {
            default: self.nullNode.run(self.thresholdCross)
            }
        case .barrier:
            if state == .passed {
                self.nullNode.run(self.barrierCross)
            }
        default:
            break
        }
    }
    
    private func handleMuteUpdate(mute: Bool) {
        let volume = Float(mute ? 0.0 : 1.0)
        self.backgroundMusic.run(SKAction.changeVolume(to: volume, duration: 0.5))
        self.nullNode.run(SKAction.changeVolume(to: volume, duration: 0.5))
    }
}
