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

// @RENAME: "GameView..." was autofilled
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // @TODO: For now launch the game view.
        if let view = self.view as! SKView? {
            
            // This is the important bit vvv
            let scene = GameController(size: view.frame.size)
            
            scene.scaleMode = .aspectFit
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene) // @TODO: Add transition.
        } else {
            // @TODO: Do better error handling.
            print("ERROR....");
        }
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
