//
//  TestScene.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

protocol EventDelegate {
    func addEvent(_ event: KernelEvent)
}

class GameScene: SKScene, EventDelegate {
    
    private var manager: SceneManager!
    
    private var kernel: Kernel!
    private var observers: [Observer]!
    
    private var queuedEvents = [KernelEvent]()
    private var previousTime: TimeInterval = 0
    private var input = Input()
    
    static func make(size: CGSize, manager: SceneManager) -> GameScene {
        let instance = GameScene(size: size)
        instance.manager = manager
        instance.kernel = KernelMasterFactory().make()
        instance.observers = [EntityRenderer.make(scene: instance,
                                                  delegate: BarrierRendererDelegate.make(frame: instance.frame)),
                              EntityRenderer.make(scene: instance,
                                                  delegate: ThresholdRendererDelegate.make(frame: instance.frame)),
                              PlayerRenderer.make(scene: instance, state: instance.kernel.getState()),
                              PauseRenderer.make(scene: instance, delegate: instance, manager: manager),
                              ResultsRenderer.make(scene: instance, delegate: instance),
                              SkyRenderer.make(scene: instance),
                              AudioRenderer.make(scene: instance),
                              ButtonRenderer.make(scene: instance)]
        return instance
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .darkText
        
        // @TEMP
        //self.kernel.addEvent(event: .settingsMuteUpdate(mute: true))
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        // @TEMP
        for event in self.getOutsideEvents() {
            self.kernel.addEvent(event: event)
        }
        
        let events = self.kernel.update(deltaTime: dt)
        for observer in self.observers {
            for event in events {
                observer.observe(event: event)
            }
        }
    }
    
    func addEvent(_ event: KernelEvent) {
        self.queuedEvents.append(event)
    }
    
    private func getOutsideEvents() -> [KernelEvent] {
        var events = [KernelEvent]()
        events.append(.positionTargetUpdate(target: self.input.getCurrent()))
        events.append(contentsOf: self.queuedEvents)
        self.queuedEvents.removeAll()
        return events
    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let lane = (location.x > self.frame.midX) ? 1 : -1
            self.input.addInput(target: lane)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.input.removeInput(count: touches.count)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.input.removeInput(count: touches.count)
    }
}
