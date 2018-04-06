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
    private let deathSound: SKAction
    
    private let musicNode: SKAudioNode
    
    override init() {
        // @TODO: Get resources from resource manager
        // Init all sound actions (equivalent to preloading)
        self.bingSound = SKAction.playSoundFileNamed("Pickup_Coin.wav", waitForCompletion: false)
        self.powerupSound = SKAction.playSoundFileNamed("Powerup.wav", waitForCompletion: false)
        self.deathSound = SKAction.playSoundFileNamed("Death.wav", waitForCompletion: false)
        
        self.musicNode = SKAudioNode(fileNamed: "dreamline_mainloop_rough.mp3")
        self.musicNode.autoplayLooped = true
        
        super.init() // @TODO: Use static make() method to avoid this
    }
    
    // I'm probably not subclassing the right class
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // @NOTE: It doesn't really matter here, but in more complex cases it
    // makes sense to have a class that just plays sounds and then a
    // controller that determines which sounds to play when
    // This method would be in the controller, not here
    func processEvents(_ events: [Event]) {
        for event in events {
            switch (event) {
                
            // Start music at beginning of round
            case .roundBegin:
                self.addChild(self.musicNode)
                
            // Stop music at end of round
            case .roundEnd:
                self.musicNode.removeFromParent()
                
            case .barrierPass:
                self.playSound(self.bingSound)
                
            case .barrierHit:
                self.playSound(self.deathSound)
                
            case .thresholdCross(let type):
                if type == .speedUp { self.playSound(self.powerupSound) }
                
            default: break
                
            }
        }
    }
    
    private func playSound(_ sound: SKAction) {
        self.run(sound)
    }
}
