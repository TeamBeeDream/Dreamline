//
//  ResultsRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/24/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ResultsRenderer: Observer {
    
    // MARK: Private Properties
    
    private var scene: SKScene!
    private var nodeContainer: SKNode!
    
    private var delegate: EventDelegate!
    
    private let storageKey = "v2_highscores"
    
    // MARK: Init
    
    static func make(scene: SKScene, delegate: EventDelegate) -> ResultsRenderer {
        let container = SKNode()
        scene.addChild(container)
        
        let instance = ResultsRenderer()
        instance.scene = scene
        instance.nodeContainer = container
        instance.delegate = delegate
        return instance
    }
    
    // MARK: Observer Methods
    
    func observe(event: KernelEvent) {
        switch event {
            
        case .flowControlPhaseUpdate(let phase):
            if phase == .begin {
                self.nodeContainer.run(SKAction.sequence([
                    SKAction.fadeOut(withDuration: 0.5),
                    SKAction.run { self.nodeContainer.removeAllChildren() },
                    SKAction.fadeIn(withDuration: 0.0)]))
            }
            
        case .roundOver(let didWin, let level, let score):
            if didWin {
                self.drawWin(level: level, points: score)
            } else {
                self.drawLose(level: level, points: score)
            }
            
        default: break
        }
    }
    
    private func drawWin(level: Int, points: Int) {
        var layout = Layout.autoLayout(fullLength: self.scene.frame.height, segments: 12)
        layout.positions.reverse()
        
        // "ROUND N"
        let roundLabel = self.headerLabel(text: "ROUND \(level)")
        roundLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[2])
        self.nodeContainer.addChild(roundLabel)
        
        // "COMPLETE"
        let completeLabel = HoppingLabelNode.make(text: "COMPLETE",
                                                  font: "Avenir-Medium",
                                                  width: self.scene.frame.width * 0.8,
                                                  color: .yellow,
                                                  secondaryColor: .gray)
        completeLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[3])
        completeLabel.zPosition = 40
        self.nodeContainer.addChild(completeLabel)
        
        // "Accuracy: X%"
        let scoreLabel = self.normalLabel(text: "Score: \(points)")
        scoreLabel.fontColor = Colors.red
        scoreLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[5])
        self.nodeContainer.addChild(scoreLabel)
        
        // "tap to continue"
        let continueLabel = self.normalLabel(text: "tap to continue")
        continueLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[10])
        continueLabel.run(Actions.fadeLoop(duration: 1.0))
        self.nodeContainer.addChild(continueLabel)
        
        // @HACK
        let continueButton = ButtonNode(color: .clear, size: self.scene.frame.size)
        continueButton.isUserInteractionEnabled = true
        continueButton.zPosition = 100 // @HARDCODED
        continueButton.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        continueButton.action = { self.delegate.addEvent(.flowControlPhaseUpdate(phase: .begin)) }
        self.nodeContainer.addChild(continueButton)
    }
    
    private func drawLose(level: Int, points: Int) {
        var layout = Layout.autoLayout(fullLength: self.scene.frame.height, segments: 10)
        layout.positions.reverse()
        
        // @TEMP
        let label = self.headerLabel(text: "GAME OVER")
        label.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[2])
        label.fontColor = Colors.red
        label.alpha = 0.0
        label.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.group([
                SKAction.fadeIn(withDuration: 0.4),
                SKAction.moveBy(x: 0.0, y: -10.0, duration: 0.4)
                ])
            ]))
        self.nodeContainer.addChild(label)
        
        // Highscores
        let newHighscore = self.createHighscore(level: level, points: points)
        var highscores = self.loadHighscores()
        highscores.append(newHighscore)
        
        highscores = highscores.sorted(by: { $0.level > $1.level || $0.points > $0.points })
        // @TODO: Limit # of highscores
        self.saveHighscores(highscores: highscores)
        
        var shownYours = false
        let max = min(highscores.count-1, 4)
        for i in 0...max {
            var highscore = highscores[i]
            if i == max && !shownYours {
                highscore = newHighscore
            }
            if same(highscore, newHighscore) {
                shownYours = false
            }
            
            let text = "\(highscore.date) Round \(highscore.level) \(highscore.points) Points"
            let scoreLabel = self.normalLabel(text: text)
            scoreLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[4 + i])
            scoreLabel.alpha = 0.0
            scoreLabel.zPosition = 30
            
            if same(highscore, newHighscore) {
                scoreLabel.fontColor = .yellow
                scoreLabel.run(SKAction.sequence([
                    SKAction.wait(forDuration: Double(i+2) * 0.5),
                    SKAction.group([
                        SKAction.fadeIn(withDuration: 0.7),
                        SKAction.moveBy(x: 0.0, y: 10.0, duration: 0.7)
                        ]),
                    Actions.fadeLoop(duration: 0.4)
                    ]))
            } else {
                scoreLabel.run(SKAction.sequence([
                    SKAction.wait(forDuration: Double(i+2) * 0.5),
                    SKAction.group([
                        SKAction.fadeIn(withDuration: 0.7),
                        SKAction.moveBy(x: 0.0, y: 10.0, duration: 0.7)
                        ])
                    ]))
            }
            self.nodeContainer.addChild(scoreLabel)
        }
        
        // @HACK
        let continueButton = ButtonNode(color: .clear, size: self.scene.frame.size)
        continueButton.zPosition = 100 // @HARDCODED
        continueButton.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        continueButton.action = { self.delegate.addEvent(.flowControlPhaseUpdate(phase: .origin)) }
        continueButton.isUserInteractionEnabled = false
        continueButton.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run { continueButton.isUserInteractionEnabled = true }]))
        self.nodeContainer.addChild(continueButton)
    }
    
    private func defaultLabel(text: String) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontName = "Avenir-Light"
        label.fontColor = .white
        label.zPosition = 40
        return label
    }
    
    private func headerLabel(text: String) -> SKLabelNode {
        let label = self.defaultLabel(text: text)
        label.fontSize = 30
        return label
    }
    
    private func normalLabel(text: String) -> SKLabelNode {
        let label = self.defaultLabel(text: text)
        label.fontSize = 24
        return label
    }
    
    private func createHighscore(level: Int, points: Int) -> Highscore {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)
        
        let dateString = "\(components.month ?? 1)/\(components.day ?? 1)"
        return Highscore(date: dateString, level: level, points: points)
    }
    
    private func loadHighscores() -> [Highscore] {
        if let data = UserDefaults.standard.object(forKey: self.storageKey) {
            let highscores = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            return highscores as! [Highscore]
        } else {
            return [Highscore]()
        }
    }
    
    private func saveHighscores(highscores: [Highscore]) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: highscores)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: self.storageKey)
        userDefaults.synchronize()
    }
    
    private func same(_ a: Highscore, _ b: Highscore) -> Bool {
        return
            a.level == b.level &&
            a.points == b.points &&
            a.date == b.date
    }
}
