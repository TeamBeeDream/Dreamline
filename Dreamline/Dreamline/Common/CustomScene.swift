//
//  CustomScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class CustomScene: SKScene {
    let manager: SceneManager
    
    init(manager: SceneManager, view: SKView) {
        self.manager = manager
        super.init(size: view.frame.size)
        self.onInit()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    // This can be overriden by subclasses
    // Called at the end of init()
    func onInit() {}
}
