//
//  GameViewController.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class DreamlineViewController: UIViewController {
    
    // MARK: Private Properties
    
    private var skview: SKView!
    
    // MARK: Init and Deinit
    
    static func make() -> DreamlineViewController {
        return DreamlineViewController()
    }
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // @NOTE: This is basically the entry point into the application
        //        This method is only expected to be called once,
        //        from here, views manage their own resources
        //        This class will be responsible for managing the
        //        FSM that controlls the subviews
        
        // Add SpriteKit view
        let skview = SKView(frame: self.view.frame)
        self.view.addSubview(skview)
        self.skview = skview
        
        //self.transitionToTitleScene()
        self.transitionToStartScene()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

protocol SceneManager {
    func transitionToTitleScene()
    func transitionToInfoScene()
    func transitionToStartScene()
    func transitionToGameScene()
    func transitionToScoreScene(score: Int)
}

extension DreamlineViewController: SceneManager {
    private func transition() -> SKTransition {
        return SKTransition.crossFade(withDuration: 0.3)
    }
    
    func transitionToTitleScene() {
        self.skview.presentScene(TitleScene(manager: self, size: self.skview.frame.size), transition: self.transition())
    }
    
    func transitionToInfoScene() {
        self.skview.presentScene(BetaInfoScene(manager: self, size: self.skview.frame.size), transition: self.transition())
    }
    
    func transitionToStartScene() {
        self.skview.presentScene(StartScene(manager: self, size: self.skview.frame.size), transition: self.transition())
    }
    
    func transitionToGameScene() {
        self.skview.presentScene(GameScene(manager: self, size: self.skview.frame.size), transition: self.transition())
    }
    
    func transitionToScoreScene(score: Int) {
        self.skview.presentScene(ScoreScene(manager: self, size: self.skview.frame.size,   score: score), transition: self.transition())
    }
}

