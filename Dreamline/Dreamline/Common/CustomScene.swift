//
//  CustomScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @TODO: Move this file somewhere other than Common/
// This should probably also not be subclassed
// Instead it should wrap the SKScene
class CustomScene: SKScene {
    
    // MARK: Private Properties
    
    var manager: SceneManager
    
    // MARK: Init
    
    init(manager: SceneManager, size: CGSize) {
        self.manager = manager
        super.init(size: size)
        
        self.onInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Should be implemented by child classes
    func onInit() {}
}
