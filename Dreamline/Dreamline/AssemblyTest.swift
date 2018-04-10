//
//  AssemblyTest.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

class ToggleBuffer<T> {
    
    private var head: Int = 0
    private var buffer: [T]!
    
    static func make(value: T) -> ToggleBuffer {
        let instance = ToggleBuffer()
        instance.buffer = [T](repeating: value, count: 2)
        return instance
    }
    
    func access() -> T {
        return self.buffer[self.head]
    }
    
    func inject(_ value: T) {
        self.buffer[self.head] = value
    }
    
    func toggle() {
        if self.head == 0   { self.head = 1 }
        else                { self.head = 0 }
    }
}

class TestScene: SKScene {
    
    // MARK: Private Properties
    
    private var framework: Framework!
    private var inputDelegate: InputDelegate!
    private var renderers: [Observer]!
    
    private var previousTime: TimeInterval = 0
    
    private var inputCount: Int = 0
    private var inputTarget: Int = 0
    
    // @HACK
    // @TODO: Create z layer lookup table
    static let TEXT_Z_POSITION: CGFloat = 1.0
    static let LINE_Z_POSITION: CGFloat = 0.0
    
    // MARK: Init
    
    // @CLEANUP
    static func make(size: CGSize,
                     state: KernelState,
                     kernels: [Kernel],
                     rules: [Rule],
                     observers: [Observer]) -> TestScene {
        
        let instance = TestScene(size: size)
        
        // @TEMP @HARDCODED
        var customObservers: [Observer] = [LineRenderer.make(scene: instance),
                                           PlayerRenderer.make(scene: instance)]
        instance.renderers = customObservers
        customObservers.append(contentsOf: observers) // @HACK
        
        let framework = DefaultFramework.make(state: state,
                                              kernels: kernels,
                                              rules: rules,
                                              observer: customObservers)
        instance.framework = framework
        instance.inputDelegate = framework // ?
        
        return instance
    }
    
    // MARK: SKScene Methods
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .darkText
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        self.framework.update(deltaTime: dt) // WOW
    }
    
    // @TEMP
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let input = location.x < self.frame.midX ? -1 : 1
            self.inputDelegate.addInput(lane: input)
        }
    }
    
    // @TEMP
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputDelegate.removeInput(count: touches.count)
    }
    
    // @TEMP
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputDelegate.removeInput(count: touches.count)
    }
}
