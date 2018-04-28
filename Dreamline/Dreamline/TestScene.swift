//
//  TestScene.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class TestScene: SKScene {
    
    private var previousTime: TimeInterval = 0
    private var kernel: Kernel!
    private var observers: [Observer]!
    
    static func make(size: CGSize) -> TestScene {
        let instance = TestScene(size: size)
        instance.kernel = KernelMasterFactory().make()
        instance.observers = [EntityRenderer.make(scene: instance,
                                                  delegate: BarrierRendererDelegate.make(frame: instance.frame)),
                              EntityRenderer.make(scene: instance,
                                                  delegate: ThresholdRendererDelegate.make(frame: instance.frame))]
        return instance
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .darkText
        let border = SKShapeNode(rect: view.frame)
        border.fillColor = .clear
        border.strokeColor = .green
        self.addChild(border)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        // @TEMP
        let events = self.kernel.update(deltaTime: dt)
        for observer in self.observers {
            for event in events {
                observer.observe(event: event)
            }
        }
    }
}
