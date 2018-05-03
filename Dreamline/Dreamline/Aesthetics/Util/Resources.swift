//
//  Resources.swift
//  Dreamline
//
//  Created by BeeDream on 5/2/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import AVFoundation

enum Texture {
    case player
    case thresholdChunk
    case thresholdRound
    case barrier
    case tiledSky1
    case tiledCloud1
    case pauseButton
}

enum Music {
    case main
    case menu
}

enum Sound {
    case barrierCross
    case barrierPass
    case thresholdRoundCross
    case thresholdChunkCross
    case playerMoveAway
    case playerMoveBack
}

class Resources {
    
    private static var instance: Resources!
    
    private var textures: [Texture: SKTexture]
    private var music: [Music: SKAudioNode]
    private var sounds: [Sound: AVPlayer]
    
    init() {
        self.textures = [Texture: SKTexture]()
        self.music = [Music: SKAudioNode]()
        self.sounds = [Sound: AVPlayer]()
    }
    
    static var shared: Resources {
        if instance == nil {
            instance = Resources()
        }
        return instance
    }
    
    func preload() {
        let frame = UIScreen.main.bounds
        self.addBarrierTexture(frame: frame)
        self.addThresholdTextures(frame: frame)
        self.addPlayerTexture()
        self.addSkyTexture()
        self.addCloudTexture()
        self.addPauseButton()
        self.addMusic()
        self.addSounds()
    }
    
    func getTexture(_ key: Texture) -> SKTexture {
        return self.textures[key]!
    }
    
    func getMusic(_ key: Music) -> SKAudioNode {
        let music = self.music[key]!
        music.removeFromParent() // @HACK
        return music
    }
    
    func getSound(_ key: Sound) -> AVPlayer {
        return self.sounds[key]!
    }
}

// Textures
extension Resources {
    private func addBarrierTexture(frame: CGRect) {
        let rect = CGRect(x: 0.0,
                          y: 0.0,
                          width: frame.width / 3.0,
                          height: 4.0)
        let shape = SKShapeNode(rect: rect)
        shape.lineWidth = 0.0
        shape.fillColor = .darkText
        self.textures[.barrier] = SKView().texture(from: shape)!
    }
    
    private func addThresholdTextures(frame: CGRect) {
        let rect = CGRect(x: 0.0,
                          y: 0.0,
                          width: frame.width,
                          height: 4.0)
        let shape = SKShapeNode(rect: rect)
        shape.lineWidth = 0.0
        
        shape.fillColor = .orange
        self.textures[.thresholdChunk] = SKView().texture(from: shape)!
        
        shape.fillColor = .purple
        self.textures[.thresholdRound] = SKView().texture(from: shape)!
    }
    
    private func addPlayerTexture() {
        self.textures[.player] = SKTexture(imageNamed: "PaperAirplaneA")
    }
    
    private func addSkyTexture() {
        self.textures[.tiledSky1] = SKTexture(imageNamed: "TiledSky1")
    }
    
    private func addCloudTexture() {
        self.textures[.tiledCloud1] = SKTexture(imageNamed: "TiledCloud1")
    }
    
    private func addPauseButton() {
        self.textures[.pauseButton] = SKTexture(imageNamed: "PauseButton")
    }
}

// Music
extension Resources {
    private func addMusic() {
        self.music[.menu] = self.loadMusic("menu_cloud_theme_2")
        self.music[.main] = self.loadMusic("Dreamline_cloud_theme")
    }
    
    private func loadMusic(_ fileName: String) -> SKAudioNode {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        return SKAudioNode(url: url!)
    }
}

// Sounds
extension Resources {
    private func addSounds() {
        self.sounds[.barrierCross] = self.loadSound("barrier_cross_quiet")
        self.sounds[.barrierPass] = self.loadSound("barrier_pass")
        self.sounds[.thresholdRoundCross] = self.loadSound("threshold_cross")
        self.sounds[.thresholdChunkCross] = self.loadSound("threshold_cross_chunk")
        self.sounds[.playerMoveAway] = self.loadSound("player_move")
        self.sounds[.playerMoveBack] = self.loadSound("player_move_2")
    }

    private func loadSound(_ fileName: String) -> AVPlayer {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        return AVPlayer(url: url)
    }
}
