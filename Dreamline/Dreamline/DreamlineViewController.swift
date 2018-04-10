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
        self.skView = skView // @IMPORTANT
        
        // @TODO: Use factory to assemble these lists
        let state = KernelState.new()
        let kernels: [Kernel] =
            [TimeKernel.make(),
             BoardKernel.make(),
             PositionKernel.make(),
             InputKernel.make(),
             StaminaKernel.make()]
        let rules: [Rule] =
            [ScrollRule.make(scrollSpeed: 1.5),
             TimeRule.make(),
             CleanupRule.make(),
             SpawnRule.make(),
             PositionRule.make(),
             StaminaRule.make(),
             LineCollisionRule.make(),
             AreaCollisionRule.make()]
        
        let scene = TestScene.make(size: skView.frame.size,
                                   state: state,
                                   kernels: kernels,
                                   rules: rules,
                                   observers: []) // @NOTE: Should Observers be just renderers?
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        //skView.isAsynchronous = true // @NOTE: I'm not sure what this does
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //let orientation = UIDevice.current.orientation.isLandscape
        //self.skView.scene!.size = self.skView.scene!.size
        // @TODO: Replace this with call to custom scene interface ( e.g. didOrientationChange(...) )
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        //return .allButUpsideDown // @TODO
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
