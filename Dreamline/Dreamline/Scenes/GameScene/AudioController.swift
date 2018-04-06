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

// @NOTE: This is an SKNode, and it's meant to be
// added to the SpriteKit scene, but it should be
// replaced with a constant AVFoundation system
class AudioNode: SKNode, AudioController {
    
    // MARK: Private Properties
    
    private var bingSound:      SKAction!
    private var powerupSound:   SKAction!
    private var deathSound:     SKAction!
    private var musicNode:      SKAudioNode!
    
    // MARK: Init
    
    static func make() -> AudioNode {
        // @TODO: Get resources from shared manager
        let instance = AudioNode()
        instance.bingSound = SKAction.playSoundFileNamed("Pickup_Coin.wav", waitForCompletion: false)
        instance.powerupSound = SKAction.playSoundFileNamed("Powerup.wav", waitForCompletion: false)
        instance.deathSound = SKAction.playSoundFileNamed("Death.wav", waitForCompletion: false)
        
        let node = SKAudioNode(fileNamed: "dreamline_mainloop_rough.mp3")
        instance.musicNode = node
        instance.musicNode.autoplayLooped = true
        
        // @BUG: For some reason, creating the audio node like this returns nil
        //instance.musicNode = SKAudioNode(fileNamed: "dreamline_mainloop_rough.mp3")
        
        return instance
    }
    
    // MARK: AudioController Methods
    
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
    
    // MARK: Private Methods
    
    private func playSound(_ sound: SKAction) {
        self.run(sound)
    }
}
