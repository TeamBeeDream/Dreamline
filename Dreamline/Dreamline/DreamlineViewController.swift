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
//    private var sceneController: SceneController!
    
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
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        self.gotoTitle()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: SceneManager Methods
    
    func gotoTitle() {
        self.skView.presentScene(TitleScene.make(size: self.skView.frame.size))
    }
    
    func gotoGame() {
        self.skView.presentScene(GameScene.make(size: self.skView.frame.size))
    }
}
