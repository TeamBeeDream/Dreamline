//
//  GameViewController.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class DreamlineViewController: UIViewController {
    
    // MARK: Init and Deinit
    
    static func make() -> DreamlineViewController {
        let instance = DreamlineViewController()
        return instance
    }
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        let skView = SKView(frame: self.view.frame)
        skView.isMultipleTouchEnabled = true
        self.view.addSubview(skView)
        
        let scene = TestScene.make(state: KernelState.new(),
                                   kernels: [TimeKernel.make(),
                                             BoardKernel.make(),
                                             PositionKernel.make(),
                                             InputKernel.make()],
                                   rules: [ScrollRule.make(scrollSpeed: 2.0),
                                           TimeRule.make(),
                                           CleanupRule.make(),
                                           SpawnRule.make(distanceBetweenEntities: 0.1),
                                           PositionRule.make()])
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        //skView.isAsynchronous = true // Whoa
        
        skView.texture(from: )
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
