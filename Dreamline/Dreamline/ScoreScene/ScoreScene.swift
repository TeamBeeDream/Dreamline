//
//  ScoreScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ScoreScene: CustomScene {
    
    let score: Int
    var highscores: [Highscore]?
    
    static var clearHighscoresOnInit = false // @HARDCODED
    
    init(view: SKView, score: Int) {
        self.score = score
        super.init(view: view)
        
        // @FIXME
        if ScoreScene.clearHighscoresOnInit {
            self.clearHighscores()
            ScoreScene.clearHighscoresOnInit = false
        }
        self.highscores = self.loadHighscores()
        self.highscores!.append(Highscore(score: score))
        self.saveHighscores(highscores: self.highscores!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadHighscores() -> [Highscore] {
        
        if let data = UserDefaults.standard.object(forKey: "highscore") {
            let highscores = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            return highscores as! [Highscore]
        } else {
            print("FAILED TO LOAD HIGHSCORES")
            return [Highscore]()
        }
    }
    
    private func saveHighscores(highscores: [Highscore]) {
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: highscores)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "highscore") // @HARDCODED
        userDefaults.synchronize()
    }
    
    private func clearHighscores() {
        
        self.saveHighscores(highscores: [Highscore]()) // @HACK
    }
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        let scoreText = SKLabelNode(text: "You got \(self.score)!")
        scoreText.position = self.frame.point(x: 0, y: -0.6)
        scoreText.fontColor = SKColor.yellow
        scoreText.alpha = 0.0
        scoreText.run(SKAction.fadeIn(withDuration: 0.45))
        self.addChild(scoreText)
        
        let subtitleText = SKLabelNode(text: "Previous scores:")
        subtitleText.position = self.frame.point(x: 0, y: -0.3)
        subtitleText.fontColor = SKColor.white
        subtitleText.alpha = 0.0
        subtitleText.run(SKAction.fadeIn(withDuration: 0.65))
        self.addChild(subtitleText)
        
        // draw highscores
        var sortedHighscores = self.highscores!.sorted(by: { $0.score > $1.score })
        for i in 0...min(sortedHighscores.count - 1, 4) {
            let highscore = sortedHighscores[i]
            let hsLabel = SKLabelNode(text: "\(highscore.score)")
            hsLabel.position = self.frame.point(x: 0, y: -0.1 + Double(i) * 0.2)
            hsLabel.fontColor = (highscore.score == self.score) ? SKColor.yellow : SKColor.white
            hsLabel.yScale = 0.0
            hsLabel.alpha = 0.0
            hsLabel.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.2 + Double(i) * 0.3),
                SKAction.group([
                    SKAction.fadeIn(withDuration: 0.65),
                    SKAction.scaleY(to: 1.0, duration: 0.5)])]))
            self.addChild(hsLabel)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // @FIXME
        //self.manager.transitionToStartScene()
    }
}


