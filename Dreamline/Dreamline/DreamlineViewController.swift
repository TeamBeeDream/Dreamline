//
//  GameViewController.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

protocol SceneManager {
    func gotoTitle()
    func gotoGame()
}

class DreamlineViewController: UIViewController, SceneManager {
    
    // MARK: Private Properties
    
    private var skView: SKView!
    
    // MARK: Init and Deinit
    
    static func make() -> DreamlineViewController {
        let instance = DreamlineViewController()
        return instance
    }
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: self.view.frame)
        self.view.addSubview(skView)
        self.skView = skView
        skView.isMultipleTouchEnabled = true
        skView.ignoresSiblingOrder = true
        skView.showsDrawCount = false
        skView.showsFPS = false
        
        self.gotoTitle()
        //self.gotoGame()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: SceneManager Methods
    
    func gotoTitle() {
        let transition = SKTransition.crossFade(withDuration: 1.0)
        transition.pausesOutgoingScene = true
        transition.pausesIncomingScene = false
        let scene = TitleScene.make(size: self.skView.frame.size, manager: self)
        self.skView.presentScene(scene, transition: transition)
    }
    
    func gotoGame() {
        let transition = SKTransition.crossFade(withDuration: 1.0)
        transition.pausesIncomingScene = false
        transition.pausesOutgoingScene = false
        
        let frame = self.skView.frame
        DispatchQueue.global(qos: .userInitiated).async {
            let scene = GameScene.make(size: frame.size, manager: self)
            DispatchQueue.main.async {
                self.skView.presentScene(scene, transition: transition)
            }
        }
    }
}
