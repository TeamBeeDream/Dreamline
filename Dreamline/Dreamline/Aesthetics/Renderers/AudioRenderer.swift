//
//  AudioRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class AudioRenderer: Observer {
    
    private var scene: SKScene!
    private var backgroundMusic: SKAudioNode!
    
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
        case .multiple(let events):
            for e in events { self.observe(event: e) }
        default: break
        }
    }
    
    private func addBackgroundMusic() {
        let musicUrl = Bundle.main.url(forResource: "Dreamline_cloud_theme", withExtension: "mp3")
        self.backgroundMusic = SKAudioNode(url: musicUrl!)
        self.backgroundMusic.autoplayLooped = true
        self.backgroundMusic.run(SKAction.changeVolume(to: 0.0, duration: 0.0)) // @TEMP
        self.backgroundMusic.run(SKAction.changeVolume(to: 1.0, duration: 1.0)) // @TEMP
        self.scene.addChild(self.backgroundMusic)
    }

    private func handleMuteUpdate(mute: Bool) {
        self.setBackgroundMusicLevel(mute: mute)
    }
    
    private func setBackgroundMusicLevel(mute: Bool) {
        if mute {
            self.backgroundMusic.run(SKAction.changeVolume(to: 0.0, duration: 0.5))
        } else {
            self.backgroundMusic.run(SKAction.changeVolume(to: 1.0, duration: 0.5))
        }
    }
}
