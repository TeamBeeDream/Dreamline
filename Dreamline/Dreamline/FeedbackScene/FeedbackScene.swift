//
//  FeedbackScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import Firebase

class FeedbackScene: CustomScene {
    
    var percentage: Double = 0.0
    
    static func make(manager: SceneManager, size: CGSize, percentage: Double) -> FeedbackScene {
        let scene = FeedbackScene(manager: manager, size: size)
        scene.percentage = percentage
        return scene
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        let percentage = Double(round(10 * (self.percentage * 100)) / 10) // @HACK
        let label = SKLabelNode(text: "\(percentage)%")
        label.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        label.fontColor = .darkText
        label.fontSize = 36
        self.addChild(label)
        
        self.sendAnalytics()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.manager.transitionToStartScene()
    }
    
    func sendAnalytics() {
        let difficulty = 0
        let percentage = self.percentage
        let feedback = Feedback.justRight.rawValue
        
        Analytics.logEvent("feedback", parameters: [
            "difficulty": difficulty as NSObject,
            "percentage": percentage as NSObject,
            "response": feedback as NSObject])
    }
}

enum Feedback: Int {
    case tooEasy = 0
    case justRight = 1
    case tooHard = 2
}
