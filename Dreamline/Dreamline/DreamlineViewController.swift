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
    
    private var skView: SKView!
    private var sceneController: SceneController!
    
    // MARK: Init and Deinit
    
    static func make() -> DreamlineViewController {
        let instance = DreamlineViewController()
        return instance
    }
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneController = DreamlineSceneController.make(size: self.view.frame.size)
        
//        let halfFrame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.width)
        let skView = SKView(frame: self.view.frame)
        skView.isMultipleTouchEnabled = true
        self.view.addSubview(skView)
        self.skView = skView // @IMPORTANT
        
//        scene.scaleMode = .aspectFit
//        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        //skView.isAsynchronous = true // @NOTE: I'm not sure what this does
        
        self.didTransition(to: .title)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        let orientation = UIDevice.current.orientation
//        if orientation.isLandscape {
//            let offset = (size.width - self.skView.frame.width) / 2.0
//            self.skView.frame.origin = CGPoint(x: offset, y: 0.0)
//        } else if orientation.isPortrait {
//            self.skView.frame.origin = CGPoint(x: 0.0, y: 0.0)
//        }
//    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown // @TODO
        //return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension DreamlineViewController: SceneDelegate {
    func didTransition(to: Scene) {
        let toScene = self.sceneController.getScene(to, delegate: self)
        self.skView.presentScene(toScene)
    }
}
