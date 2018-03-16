//
//  GameScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @NOTE: This class is fairly fixed right now
//        We should probably inject these objects
//        into this class, so that way we can test
//        different configurations of implementations
//        I.e. swap out user input with mock input
class GameScene: CustomScene {
    
    // These are all the things that need updates
    var model: GameModel = DefaultGameModel()
    var configurator: Configurator = DefaultConfigurator()
    var renderer: GameRenderer?
    var audio: AudioController?
    var scoreUpdater: ScoreUpdater = DefaultScoreUpdater()
    
    // These are the pieces of state (just data)
    var state: ModelState = ModelState.getDefault()
    var score: Score = ScoreFactory.getNew()
    var config: GameConfig = GameConfigFactory.getDefault()
    var ruleset: Ruleset = RulesetFactory.getDefault()
    
    // Internal state
    private var timeOfPreviousFrame: TimeInterval = 0
    private var numInputs: Int = 0
    private var isDead = false
    
    override func onInit() {
        // Create the renderer and add it to the view
        self.renderer = DebugRenderer(frame: self.frame)
        addChild(self.renderer as! SKNode)
        // @NOTE: It's interesting that the DebugRenderer needs
        //        to be initialized here.  The dependency is
        //        the frame of this view, the renderer can't
        //        be created without it, hence why this can't
        //        be instantiated until after GameScene's init
        
        self.audio = AudioNode()
        addChild(self.audio as! SKNode)
        
        self.backgroundColor = SKColor(red: 57.0/255.0, green: 61.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    }
    
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
            dt: dt)
        let updatedConfig = configurator.updateConfig(
            config: config,
            ruleset: ruleset,
            events: events)
        let updatedScore = scoreUpdater.updateScore(
            state: score,
            config: updatedConfig,
            ruleset: ruleset,
            events: events)
        
        // Composite
        self.state = updatedState
        self.config = updatedConfig // @TODO: should config changes be done here or in the model?
        self.score = updatedScore
        
        // This optional is dangerous :(
        self.renderer!.render(state: state, score: score, config: config, events: events)
        self.audio!.processEvents(events)
        
        // Scene stuff
        // @TODO: Move this to own function or something
        // @HACK: I don't like how the controller is responsible for
        //        invoking the end of the game round, should probably
        //        be in the modle update function
        for event in events {
            switch (event) {
            case .barrierHit(_):
                self.renderer!.killPlayer() // @HACK
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 1.0),
                    SKAction.run {
                        self.manager.transitionToScoreScene(score: self.score.points)
                    }]))
                self.isDead = true
            default: break
            }
        }
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
