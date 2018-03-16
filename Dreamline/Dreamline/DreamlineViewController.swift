//
//  GameViewController.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @CLEANUP: Should this be here or in another file?
protocol SceneManager {
    func transitionToTitleScene()
    func transitionToStartScene()
    func transitionToGameScene()
    func transitionToScoreScene(score: Int)
}

// @IDEA:
// In the other model, the update tick was called
// every frame interval, but since we can't do that
// at this level, we can trigger update by events
// calling functions in this class

// this class is connected to the Main.storyboard stuff
// so it's tough to do an init()
// this is basically rock bottom of the program
// @RENAME: I'm not sure if this is a 'ViewController' per se
//          Maybe something like 'DreamlineBase' or 'DreamlineProgram'
//          Whatever it is, it should indicate that this is the 'bottom' of the program
class DreamlineViewController: UIViewController {
    
    var skview: SKView {
        
        return self.view as! SKView!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Setup skview
        self.skview.showsFPS = true
        self.skview.showsNodeCount = true
        
        // :Transition to 'title' scene
        self.transitionToTitleScene()
        // @HARDCODED: There could be some sort of switch here
        //             Could be a way to launch game in "develop mode" vs "master mode"
        //             How should this information be added to the children objects
        
        // It could be like reverse events
        // Instead of calling func down to the child,
        // the child calls up the the parent pointer
        // Something generic like addEvent(enum)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // @TODO: Release any cached data, images, etc that aren't in use
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all // @TODO: I'm not sure why this is like this.
        }
    }
    
    override var shouldAutorotate: Bool {
        
        return false // Change this when there is a reason to autorotate
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true // Change this when there is a reason to show the status bar
    }
}

// @TODO: Bolster scene management
//        Manage menory by cachine CustomScenes
extension DreamlineViewController: SceneManager {
    
    func transitionToTitleScene() {
        let titleScene = TitleScene(manager: self, view: self.skview)
        titleScene.scaleMode = .aspectFit
        
        self.skview.presentScene(titleScene)
    }
    
    // @TODO: Pass transition type in
    func transitionToStartScene() {
        
        // Transition to a new StartScene
        
        // @NOTE: It's strange that you have to create a new
        //        instance each time this method is called.
        //        How should this instances be held in memory?
        let startScene = StartScene(manager: self, view: self.skview)
        startScene.scaleMode = .aspectFit // What does this do?
        
        // @CLEANUP: This transition could be stored somewhere else
        //           Like a 'resource' manager, use enum as key
        let transition = SKTransition.crossFade(withDuration: 0.5)
        // Pause outgoing scene, can't tell what it is :(
        transition.pausesOutgoingScene = true
        // Pause incoming StartScene
        transition.pausesIncomingScene = true
        self.skview.presentScene(startScene, transition: transition)
    }
    
    func transitionToGameScene() {
        
        // Transition to a new GameScene
        
        // @NOTE: Temporarily, completely reset game instance each time
        let gameScene = GameScene(manager: self, view: self.skview)
        gameScene.scaleMode = .aspectFit // What does this do?
        
        // @CLEANUP: This transition could be stored somewhere else
        //           Like a 'resource' manager, use enum as key
        let transition = SKTransition.moveIn(with: SKTransitionDirection.down, duration: 1.0)
        // Pause outgoing scene, expected to be a StartScene
        transition.pausesOutgoingScene = true
        // Pause incoming GameScene
        transition.pausesIncomingScene = false
        self.skview.presentScene(gameScene, transition: transition)
    }
    
    func transitionToScoreScene(score: Int) {
        
        // Create new score view (don't hold in memory)
        
        // @NOTE: This creates a new ScoreScene every time we transition to it
        //        since it happens so frequently, we can store it in memory
        //        but we have to manage its state
        //        We could send events to all scenes...
        //        Is that something we should invest time into?
        let scoreScene = ScoreScene(manager: self, view: self.skview, score: score)
        // for example, ScoreScene could respond to events like .gameOver
        // or even something like .transition...
        
        // @CLEANUP: This transition could be stored somewhere else
        //           Like a 'resource' manager, use enum as key
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        // Pause outgoing scene, expected to be a GameScene
        transition.pausesOutgoingScene = true
        // Pause incoming ScoreScene
        transition.pausesIncomingScene = true
        self.skview.presentScene(scoreScene, transition: transition)
        
        // @BUG: There is a bug that only happens when you hit a barrier
        //       and then hit another barrier during the transition between scenes
        //
        //       When that happens, this method is called more than once,
        //       and the transition stutters
        //       To avoid this, the 'outgoing' game scene is paused during the transition
        //       But it should probably have some sort of flag that disrupts
        //       the flow of events in the game scene (like disabling it)
    }
}

