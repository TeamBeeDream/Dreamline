//
//  FeedbackScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import Firebase

// @TEMPORARY: This scene is only for the beta
// it should be removed before the final release
class FeedbackScene: CustomScene {
    
    var percentage: Double = 0.0
    var difficulty: Double = 0.0
    
    var hardButton: DButton!
    var easyButton: DButton!
    var rightButton: DButton!
    
    var listening: Bool = true
    
    static func make(manager: SceneManager, size: CGSize,
                     percentage: Double, difficulty: Double) -> FeedbackScene {
        let scene = FeedbackScene(manager: manager, size: size)
        scene.percentage = percentage
        scene.difficulty = difficulty
        return scene
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(red: 220.0/255.0,
                                       green: 190.0/255.0,
                                       blue: 211.0/255.0,
                                       alpha: 1.0)
        
        let label = SKLabelNode(text: "Round Complete")
        label.position = view.frame.point(x: 0.0, y: -0.7)
        label.fontColor = .darkText
        label.fontSize = 36
        self.addChild(label)
        
        let desc = SKLabelNode(text: "Please rate the difficulty")
        desc.position = view.frame.point(x: 0.0, y: -0.4)
        desc.fontColor = .darkText
        desc.fontSize = 20
        self.addChild(desc)
        
        let buttonWidth = view.frame.width * 0.85
        let buttonHeight = view.frame.height * 0.15
        let buttonSize = CGSize(width: buttonWidth, height: buttonHeight)
        let buttonColor = SKColor(red: 121.0/255.0,
                                  green: 163.0/255.0,
                                  blue: 145.0/255.0,
                                  alpha: 1.0)
        
        let hardButton = DButton.make(text: "Too hard",
                                      size: buttonSize,
                                      color: buttonColor)
        hardButton.position = view.frame.point(x: 0.0, y: 0.4)
        self.addChild(hardButton)
        self.hardButton = hardButton
        
        let easyButton = DButton.make(text: "Too easy",
                                      size: buttonSize,
                                      color: buttonColor)
        easyButton.position = view.frame.point(x: 0.0, y: 0.0)
        self.addChild(easyButton)
        self.easyButton = easyButton
        
        let rightButton = DButton.make(text: "Just right",
                                       size: buttonSize,
                                       color: buttonColor)
        rightButton.position = view.frame.point(x: 0.0, y: 0.8)
        self.addChild(rightButton)
        self.rightButton = rightButton
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.listening { return }
        
        for t in touches {
            let loc = t.location(in: self)
            let fastFade = SKAction.fadeOut(withDuration: 0.3)
            
            var response: Feedback = .justRight
            if self.hardButton.contains(loc) {
                response = .tooHard
                self.easyButton.run(fastFade)
                self.rightButton.run(fastFade)
            } else if self.easyButton.contains(loc) {
                response = .tooEasy
                self.hardButton.run(fastFade)
                self.rightButton.run(fastFade)
            } else if self.rightButton.contains(loc) {
                response = .justRight
                self.hardButton.run(fastFade)
                self.easyButton.run(fastFade)
            }
            
            self.listening = false
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run {
                    self.sendAnalytics(response: response)
                    self.manager.transitionFromFeedbackScene(response: response)
                }]))
        }
    }
    
    func sendAnalytics(response: Feedback) {
        let difficulty = self.difficulty
        let percentage = self.percentage
        let feedback = response.rawValue
        
        Analytics.logEvent("feedback", parameters: [
            "difficulty": difficulty as NSObject,
            "percentage": percentage as NSObject,
            "response": feedback as NSObject])
    }
}

enum Feedback: Int {
    case tooHard = 0
    case justRight = 1
    case tooEasy = 2
}

class DButton: SKNode {
    static func make(text: String, size: CGSize, color: UIColor) -> DButton {
        let rect = CGRect(x: size.width * -0.5,
                          y: size.height * -0.5,
                          width: size.width,
                          height: size.height)
        let buttonBG = SKShapeNode(rect: rect, cornerRadius: 5.0)
        buttonBG.fillColor = color
        buttonBG.strokeColor = .clear
        
        let label = SKLabelNode(text: text)
        label.position = CGPoint(x: 0, y: -label.fontSize * 0.35)
        label.fontColor = .white
        
        let button = DButton()
        button.addChild(buttonBG)
        button.addChild(label)
        return button
    }
}
