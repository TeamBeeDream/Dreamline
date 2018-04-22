//
//  SceneController.swift
//  Dreamline
//
//  Created by BeeDream on 4/13/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

enum Scene {
    case title
    case menu
    case game
    case results
    case config
}

protocol SceneController {
    func getScene(_ scene: Scene, delegate: SceneDelegate) -> SKScene?
}

protocol SceneDelegate {
    func didTransition(to: Scene)
}

class DreamlineSceneController: SceneController {
    
    // MARK: Private Properties
    
    private var scenes: [Scene: SKScene]!
    private var size: CGSize!
    
    // MARK: Init
    
    static func make(size: CGSize) -> DreamlineSceneController {
        let instance = DreamlineSceneController()
        instance.scenes = [Scene: SKScene]()
        instance.size = size
        return instance
    }
    
    // MARK: SceneController Methods
    
    func getScene(_ scene: Scene, delegate: SceneDelegate) -> SKScene? {
        switch scene {
        case .title:
            return TitleScene.make(size: self.size, delegate: delegate)
        case .menu:
            return MenuScene.make(size: self.size, delegate: delegate)
        case .game:
            return GameSceneFactory.master(size: self.size, delegate: delegate)
        default: assert(false) // @TEMP
        }
    }
}
