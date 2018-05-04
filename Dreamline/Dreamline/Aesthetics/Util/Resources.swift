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
    case thresholdRecovery
    case barrier
    case tiledCloudBG
    case pauseButton
    case cloudA
    case cloudB
    case cloudC
    case cloudD
    case cloudE
    case heart
    case arrowButton
    case playButton
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
    case thresholdRecovery
    case playerMoveAway
    case playerMoveBack
    case menuClick
    case highscore
}

class Resources {
    
    private static var instance: Resources!
    
    private var textures: [Texture: SKTexture]
    private var music: [Music: SKAudioNode]
    private var sounds: [Sound: SKAction]
    
    init() {
        self.textures = [Texture: SKTexture]()
        self.music = [Music: SKAudioNode]()
        self.sounds = [Sound: SKAction]()
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
        self.addCloudTextures()
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
    
    func getSound(_ key: Sound) -> SKAction {
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
        let fill = SKShapeNode(rect: rect)
        fill.lineWidth = 0.0
        fill.zPosition = 2
        let shadow = SKShapeNode(rect: rect)
        shadow.lineWidth = 0.0
        shadow.position.y = -1.0
        shadow.zPosition = 1
        
        let shape = SKNode()
        shape.addChild(shadow)
        shape.addChild(fill)
        
        fill.fillColor = Colors.gray
        shadow.fillColor = Colors.purple
        self.textures[.barrier] = SKView().texture(from: shape)!
    }
    
    private func addThresholdTextures(frame: CGRect) {
        let rect = CGRect(x: 0.0,
                          y: 0.0,
                          width: frame.width,
                          height: 6.0)
        let fill = SKShapeNode(rect: rect)
        fill.lineWidth = 0.0
        fill.zPosition = 2
        
        let shadow = SKShapeNode(rect: rect)
        shadow.lineWidth = 0.0
        shadow.position.y = -1.0
        shadow.zPosition = 1
        
        let shape = SKNode()
        shape.addChild(fill)
        shape.addChild(shadow)
        
        fill.fillColor = Colors.yellow
        shadow.fillColor = Colors.purple
        self.textures[.thresholdChunk] = SKView().texture(from: shape)!
        
        fill.fillColor = Colors.red
        shadow.fillColor = Colors.orange
        self.textures[.thresholdRound] = SKView().texture(from: shape)!
        
        fill.fillColor = .white
        shadow.fillColor = Colors.pink
        self.textures[.thresholdRecovery] = SKView().texture(from: shape)!
    }
    
    private func addPlayerTexture() {
        self.textures[.player] = SKTexture(imageNamed: "PaperAirplaneB")
        self.textures[.heart] = SKTexture(imageNamed: "Heart")
    }
    
    private func addSkyTexture() {
        self.textures[.tiledCloudBG] = SKTexture(imageNamed: "TiledCloudBG")
    }
    
    private func addCloudTextures() {
        self.textures[.cloudA] = SKTexture(imageNamed: "CloudA")
        self.textures[.cloudB] = SKTexture(imageNamed: "CloudB")
        self.textures[.cloudC] = SKTexture(imageNamed: "CloudC")
        self.textures[.cloudD] = SKTexture(imageNamed: "CloudD")
        self.textures[.cloudE] = SKTexture(imageNamed: "CloudE")
    }
    
    private func addPauseButton() {
        self.textures[.pauseButton] = SKTexture(imageNamed: "PauseButton")
        self.textures[.arrowButton] = SKTexture(imageNamed: "ArrowButton")
        
        let playLabel = SKLabelNode(text: "PLAY")
        playLabel.fontColor = Colors.gray
        playLabel.fontSize = 36
        playLabel.fontName = "Avenir-Medium"
        self.textures[.playButton] = SKView().texture(from: playLabel)!
    }
}

// Music
extension Resources {
    private func addMusic() {
        self.music[.menu] = self.loadMusic("cloud_theme_menu_v3")
        self.music[.main] = self.loadMusic("cloud_course_theme")
    }
    
    private func loadMusic(_ fileName: String) -> SKAudioNode {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        return SKAudioNode(url: url!)
    }
}

// Sounds
extension Resources {
    private func addSounds() {
        self.sounds[.barrierCross] = self.loadSound("barrier_cross_v4.mp3")
        self.sounds[.barrierPass] = self.loadSound("barrier_pass_v2.mp3")
        self.sounds[.thresholdRoundCross] = self.loadSound("threshold_cross_v2.mp3")
        self.sounds[.thresholdChunkCross] = self.loadSound("threshold_cross_chunk_v2.mp3")
        self.sounds[.thresholdRecovery] = self.loadSound("recovery_v5.mp3")
        self.sounds[.playerMoveAway] = self.loadSound("player_move_v3.mp3")
        self.sounds[.playerMoveBack] = self.loadSound("player_move_2_v2.mp3")
        self.sounds[.menuClick] = self.loadSound("menu_click.mp3")
        self.sounds[.highscore] = self.loadSound("high_score.mp3")
    }

    private func loadSound(_ fileName: String) -> SKAction {
        return SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
    }
}
