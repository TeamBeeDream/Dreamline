//
//  GameScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import Firebase

// @NOTE: This class is fairly fixed right now
//        We should probably inject these objects
//        into this class, so that way we can test
//        different configurations of implementations
//        I.e. swap out user input with mock input
class GameScene: CustomScene {
    
    // Data
    var state: ModelState = ModelStateFactory.getDefault()
    var score: Score = ScoreFactory.getNew()
    var config: GameConfig = GameConfigFactory.getChallengeConfig() // @HARDCODED
    var ruleset: Ruleset = RulesetFactory.getDefault()
    
    // Protocols
    var model: GameModel = DefaultGameModel()
    var positioner: Positioner = DefaultPositioner()
    var board: Board = DefaultBoard()
    var sequencer: Sequencer = DynamicSequencer.make()
    var configurator: Configurator = DefaultConfigurator.make()
    var scoreUpdater: ScoreUpdater = DefaultScoreUpdater.make()
    var focus: Focus = DefaultFocus.make()
    
    // View Modules
    var renderer: GameRenderer!
    var audio: AudioController!
    var analytics: AnalyticsListener!
    
    // GameScene State
    private var timeOfPreviousFrame: TimeInterval = 0
    private var numInputs: Int = 0
    private var isDead = false
    private var totalBarriers: Int = 0
    private var passedBarriers: Int = 0
    
    // MARK: Init
    
    static func make(manager: SceneManager, frame: CGRect, speed: Speed) -> GameScene {
        
        let renderer = DebugRenderer(frame: frame)
        let audio = AudioNode.make()
        
        let scene = GameScene(manager: manager, size: frame.size)
        
        scene.config.boardScrollSpeed = speed
        
        scene.renderer = renderer
        scene.addChild(renderer)
        
        scene.audio = audio
        scene.addChild(audio)
        
        scene.analytics = DefaultAnalyticsListener.make()
        
        return scene
    }
    
    override func onInit() {
        self.backgroundColor = SKColor(red: 57.0/255.0, green: 61.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    }
    
    // MARK: SKScene Methods
    
    override func didMove(to view: SKView) {
        // This is called whenever this scene is incoming
        // So if this instance already existed, it
        // will resume wherever it was last left off
        
        // @HACK: Need a better way to fire off round begin event
        //        Should probably be at the end of an animation
        //        I'm using this to start the main music loop
        //        (hence why only the audio is being updated)
        self.audio!.processEvents([.roundBegin])
    }
    
    override func willMove(from view: SKView) {
        // @BUG: Input needs to be reset,
        // When we transition away from this scene,
        // any remaining touches will need to be cleared
        // Or else the input gets stuck and the total
        // number of touches can never get back to 0
        self.removeInput(count: self.numInputs) // @TODO: make clearInput() method
        
        // @HACK: Stop music
        self.audio!.processEvents([.roundEnd])
    }
    
    deinit {
        // @ROBUSTNESS: Ensure all memory is freed
        self.renderer!.free()
        self.removeAllActions()
        self.removeAllChildren()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Update all of the modules
        var dt = currentTime - self.timeOfPreviousFrame
        self.timeOfPreviousFrame = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        // @HACK: Need a better way to handle when the player has died
        //        Should probably be a FSM
        if self.isDead {
            dt *= 0.2
        }
        
        // Update
        let (updatedState, events) = model.update(
            state: state,
            config: config,
            ruleset: ruleset,
            positioner: positioner,
            board: board,
            sequencer: sequencer,
            focus: focus,
            dt: dt)
        let updatedConfig = configurator.updateConfig(
            config: config,
            ruleset: ruleset,
            events: events)
        let updatedScore = scoreUpdater.updateScore(
            state: score,
            config: updatedConfig,
            events: events)
        
        // Composite
        self.state = updatedState
        self.config = updatedConfig // @TODO: should config changes be done here or in the model?
        self.score = updatedScore
        
        // Send events to all "view" modules
        self.renderer.render(state: state, score: score, config: config, events: events)
        self.audio.processEvents(events)
        self.analytics.processEvents(events, config: config)
        
        // Scene stuff
        // @TODO: Move this to own function or something
        // @FIXME: GameScene should not be responsible for
        //         controlling sequence of events
        //         It should just send events to VC
        for event in events {
            switch (event) {
                
            case .barrierPass:
                self.passedBarriers += 1
                self.totalBarriers += 1
                
            case .barrierHit:
                self.totalBarriers += 1
                self.renderer!.killPlayer() // @HACK
                
            // @NOTE: Should probably just pass events
            // down to the renderer
            case .thresholdCross(let type): // @TEMPORARY
                if type == .roundOver {
                    self.renderer!.roundOver() // @HACK
                    self.roundOver()
                }
                
            case .focusGone: // @HACK
                self.renderer!.roundOver()
                self.roundOver() // @TODO: This should be determined by the config
                
            default: break
                
            }
        }
    }
    
    private func roundOver() {
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.25),
            SKAction.run {
                self.manager.transitionToScoreScene(score: self.score.points)
            }]))
        self.isDead = true
    }
}

// @CLEANUP: this works, but is a little awkward
// input should probably be its own class,
// need to figure out how to properly update it
// for now, this input is hardcoded here
// @NOTE: This code mutates the state,
//        we should use clone() instead
extension GameScene {
    private func addInput(_ lane: Int) {
        // @HACK
        if self.isDead { return }
        
        // Add input, change target position to newest input
        state.positionState.target = Double(lane)
        self.numInputs += 1
    }
    
    private func removeInput(count: Int) {
        // @HACK
        if self.isDead { return }
        
        // Remove input, if 0 touches then change target position to 0 (center)
        self.numInputs -= count
        if (self.numInputs == 0) {
            state.positionState.setTarget(Lane.center)
        }
    }
    
    private func clearInput() {
        self.removeInput(count: self.numInputs)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let position = t.location(in: self.view)
            if position.x < self.frame.midX {
                self.addInput(Lane.left.rawValue)
            } else {
                self.addInput(Lane.right.rawValue)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeInput(count: touches.count)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeInput(count: touches.count)
    }
}
