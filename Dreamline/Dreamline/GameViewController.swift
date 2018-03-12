//
//  GameViewController.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneManager {
    func moveToStartScene()
    func moveToGameScene()
    //func moveToScoreScene()
}

// @RENAME: "GameView..." was autofilled
// this class is connected to the Main.storyboard stuff
// so it's tough to do an init()
class GameViewController: UIViewController {

    // scenes
    // @NOTE: these are both CustomScenes now,
    // so it may make sense to use an enum to
    // switch to a new state instead of pre-
    // defined methods
    var currentScene: SKScene?
    var upcomingScene: SKScene?
    
    //var startScene = StartScene()
    var startScene: StartScene?
    var gameScene: GameController?
    
    // this is closest thing to init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view / scenes
        if let view = self.view as! SKView? {
            view.showsFPS = true
            view.showsNodeCount = true
            
            // setup scenes
            self.startScene = StartScene(manager: self, view: view)
            self.startScene!.scaleMode = .aspectFit
            
            self.gameScene = GameController(manager: self, view: view)
            self.gameScene!.scaleMode = .aspectFit
        } else { assert( false ) }
        
        // move to first view
        self.moveToStartScene() // @HARDCODED
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// @TODO: bolster scene management
extension GameViewController: SceneManager {
    func moveToStartScene() {
        if let view = self.view as! SKView! {
            let transition = SKTransition.doorsOpenVertical(withDuration: 1.0)
            transition.pausesIncomingScene = true
            transition.pausesOutgoingScene = true
            
            view.presentScene(self.startScene!, transition: transition)
        }
    }
    
    func moveToGameScene() {
        if let view = self.view as! SKView? {
            let transition = SKTransition.doorsOpenVertical(withDuration: 1.0)
            transition.pausesIncomingScene = true
            transition.pausesOutgoingScene = true
            
            view.presentScene(self.gameScene!, transition: transition)
        }
    }
}

