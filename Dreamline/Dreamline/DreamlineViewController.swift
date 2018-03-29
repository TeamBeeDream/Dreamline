//
//  GameViewController.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // @NOTE: This is basically the entry point into the application
        //        This method is only expected to be called once,
        //        from here, views manage their own resources
        //        This class will be responsible for managing the
        //        FSM that controlls the subviews
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
