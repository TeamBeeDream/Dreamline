//
//  AssemblyTest.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

class TestViewDelegate: NSObject, SKViewDelegate {
    
    func view(_ view: SKView, shouldRenderAtTime time: TimeInterval) -> Bool {
        // @TODO: Use this to determine when to render the next frame
        return true
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
        let barrierRenderer = EntityRenderer.make(scene: instance,
                                                  delegate: BarrierRendererDelegate.make(frame: instance.frame))
        let areaRenderer = EntityRenderer.make(scene: instance,
                                               delegate: AreaRendererDelegate.make(frame: instance.frame,
                                                                                   state: state))
        
        var customObservers: [Observer] = [barrierRenderer,
                                           areaRenderer,
                                           PlayerRenderer.make(scene: instance),
                                           ThresholdRenderer.make(scene: instance),
                                           OrbRenderer.make(scene: instance)]
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
        
        // @TEMP
        let border = SKShapeNode(rect: view.frame)
        border.fillColor = .clear
        border.strokeColor = .cyan
        self.addChild(border)
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
