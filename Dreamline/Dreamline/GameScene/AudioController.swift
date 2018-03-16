//
//  AudioController.swift
//  Dreamline
//
//  Created by BeeDream on 3/14/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

protocol AudioController {
    func processEvents(_ events: [Event])
}

class AudioNode: SKNode, AudioController {
    
    private let bingSound: SKAction
    private let powerupSound: SKAction
    private let slowdownSound: SKAction
    private let deathSound: SKAction
    private let blipSound: SKAction
    
    //private let musicSound: SKAction
    private let musicNode: SKAudioNode
    
    override init() {
        // @TODO: Get resources from resource manager
        // Init all sound actions (equivalent to preloading)
        self.bingSound = SKAction.playSoundFileNamed("Pickup_Coin.wav", waitForCompletion: false)
        self.powerupSound = SKAction.playSoundFileNamed("Powerup.wav", waitForCompletion: false)
        self.slowdownSound = SKAction.playSoundFileNamed("slowdown_effect.mp3", waitForCompletion: false)
        self.deathSound = SKAction.playSoundFileNamed("Death.wav", waitForCompletion: false)
        self.blipSound = SKAction.playSoundFileNamed("Blip.wav", waitForCompletion: true)
        self.musicNode = SKAudioNode(fileNamed: "dreamline_mainloop_rough.mp3")
        self.musicNode.autoplayLooped = true
        
        super.init()
    }
    
    // I'm probably not subclassing the right class
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func processEvents(_ events: [Event]) {
        for event in events {
            switch (event) {
            case .roundBegin:
                self.addChild(self.musicNode)
            case .roundEnd:
                self.musicNode.removeFromParent()
            case .barrierPass(_):
                self.playSound(self.bingSound)
            case .modifierGet(_, let type):
                switch (type) {
                case .speedUp: self.playSound(self.powerupSound)
                case .speedDown: self.playSound(self.slowdownSound)
                default: break
                }
            case .barrierHit(_):
                self.playSound(self.deathSound)
            case .changedLanes:
                self.playSound(self.blipSound)
            default: break
            }
        }
    }
    
    private func playSound(_ sound: SKAction) {
        self.run(sound)
    }
}
