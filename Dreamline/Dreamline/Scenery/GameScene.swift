//
//  GameScene.swift
//  Dreamline
//
//  Created by BeeDream on 4/13/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

protocol GameDelegate {
    func pause()
    func unpause()
    func gotoMenu()
}

class GameScene: SKScene, GameDelegate {
    
    // MARK: Private Properties
    
    private var sceneDelegate: SceneDelegate?
    
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
                     observers: [Observer],
                     delegate: SceneDelegate?) -> GameScene {
        
        let instance = GameScene(size: size)
        instance.sceneDelegate = delegate
        
        // @TEMP @HARDCODED
        let barrierRenderer = EntityRenderer.make(scene: instance,
                                                  delegate: BarrierRendererDelegate.make(frame: instance.frame))
        let areaRenderer = EntityRenderer.make(scene: instance,
                                               delegate: AreaRendererDelegate.make(frame: instance.frame,
                                                                                   state: state))
        let thresholdRenderer = EntityRenderer.make(scene: instance,
                                                    delegate: ThresholdRendererDelegate.make(frame: instance.frame))
        let orbRenderer = EntityRenderer.make(scene: instance,
                                              delegate: OrbRendererDelegate.make(frame: instance.frame))
        let pauseRenderer = PauseRenderer.make(scene: instance)
        pauseRenderer.setDelegate(instance)
        
        var customObservers: [Observer] = [barrierRenderer,
                                           areaRenderer,
                                           thresholdRenderer,
                                           orbRenderer,
                                           pauseRenderer,
                                           PlayerRenderer.make(scene: instance),
                                           ResultsRenderer.make(scene: instance)]
        instance.renderers = customObservers
        customObservers.append(contentsOf: observers) // @HACK
        
        let framework = DefaultFramework.make(state: state,
                                              kernels: kernels,
                                              rules: rules,
                                              observer: customObservers)
        instance.framework = framework
        instance.inputDelegate = framework // ?
        framework.delegate = instance
        
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
        
        // @HACK
        self.framework.addInstruction(instruction: .updatePhase(.setup))
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        self.framework.update(deltaTime: dt)
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
        self.inputDelegate.triggerTap()
    }
    
    // @TEMP
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputDelegate.removeInput(count: touches.count)
    }
    
    // MARK: Game Delegate Methods
    
    func pause() {
        self.framework.addInstruction(instruction: .pause)
    }
    
    func unpause() {
        self.framework.addInstruction(instruction: .unpause)
    }
    
    func gotoMenu() {
        self.sceneDelegate?.didTransition(to: .menu)
    }
}

extension GameScene: FrameworkDelegate {
    func tempTransition() {
        self.sceneDelegate!.didTransition(to: .title)
    }
}

class GameSceneFactory {
    static func master(size: CGSize, delegate: SceneDelegate?) -> GameScene {
        let state = KernelState.new()
        let kernels: [Kernel] =
            [TimeKernel.make(),
             BoardKernel.make(),
             PositionKernel.make(),
             InputKernel.make(),
             StaminaKernel.make(),
             SpeedKernel.make(),
             ScoreKernel.make(),
             PhaseKernel.make()]
        let rules: [Rule] =
            [ScrollRule.make(),
             TimeRule.make(),
             CleanupRule.make(),
             SpawnRule.make(),
             PositionRule.make(),
             //StaminaRule.make(),
             LineCollisionRule.make(),
             BarrierRule.make(),
             PhaseRules.make(),
             RoundOverRule.make(),
             InputTapRules.make()]
        
        return GameScene.make(size: size,
                              state: state,
                              kernels: kernels,
                              rules: rules,
                              observers: [],
                              delegate: delegate)
    }
}
