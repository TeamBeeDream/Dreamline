//
//  GameScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @RENAME: this is the controller
// this class should be able to take in a set of
// interfaced objects and just run, so we can
// reuse this at different parts of the game
// ex: demo mode, soap testing, etc
// but since this is tied to CustomScene
// it may be more difficult than its worth
class GameScene: CustomScene {
    
    // @TODO: should probably pass these in on construction
    // i.e. manage setting them up at a higher level
    var model: GameModel = DefaultGameModel()
    var rulesetModifier: RulesetModifier = DefaultRulesetModifier()
    var renderer: GameRenderer?
    var scoreUpdater: ScoreUpdater = DefaultScoreUpdater()
    
    var state: ModelState = ModelState.getDefault()
    var score: Score = ScoreFactory.getNew()
    var config: GameConfig = GameConfigFactory.getDefault()
    var ruleset: Ruleset = RulesetFactory.getDefault()
    
    // private state
    var previousTime: TimeInterval = 0
    var numInputs: Int = 0
    
    override func onInit() {
        self.renderer = DebugRenderer(frame: self.frame)
        addChild(self.renderer as! SKNode)
    }
    
    override func didMove(to view: SKView) {
        // this is the "reset" function
        // called each time the manager
        // transitions to this scene.
        
        // @BUG: should reset the game
        // or just have the viewcontroller
        // make a new instance, I'm not sure
        // what the benefits of either are.
    }
    
    override func willMove(from view: SKView) {
        // @BUG: input needs to be reset,
        // when we transition away from this
        // scene, any remaining touches will need to be cleared
        self.removeInput(count: self.numInputs) // @TODO: make clearInput() method
    }
    
    deinit {
        // @ROBUSTNESS: ensure all memory is freed
        self.renderer!.free()
        self.removeAllActions()
        self.removeAllChildren()
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        // update
        let (updatedState, events) = model.update(
            state: state,
            config: config,
            dt: dt)
        let updatedConfig = rulesetModifier.updateRuleset(
            ruleset: ruleset,
            config: config,
            events: events)
        let updatedScore = scoreUpdater.updateScore(
            state: score,
            config: updatedConfig,
            events: events)
        
        // composite
        self.state = updatedState
        self.config = updatedConfig // @TODO: should config changes be done here or in the model?
        self.score = updatedScore
        
        // this optional is dangerous :(
        self.renderer!.render(state: state, score: score, config: config, events: events)
        
        // scene stuff
        // @TODO: move this to own function or something
        for event in events {
            switch (event) {
            case .barrierHit(_):
                self.manager.moveToScoreScene(score: self.score.points)
            default: break
            }
        }
    }
}

// @CLEANUP: this works, but is a little awkward
// input should probably be its own class,
// need to figure out how to properly update it
// for now, this input is hardcoded here
extension GameScene {
    private func addInput(_ lane: Int) {
        state.targetOffset = Double(lane)
        self.numInputs += 1
    }
    
    private func removeInput(count: Int) {
        self.numInputs -= count
        if (self.numInputs == 0) {
            state.targetOffset = 0.0
        }
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
