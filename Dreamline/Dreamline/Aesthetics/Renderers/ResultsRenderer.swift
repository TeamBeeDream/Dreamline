//
//  ResultsRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/24/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import FirebaseAnalytics

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
            if phase == .begin || phase == .select {
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
                                                  color: Colors.yellow,
                                                  secondaryColor: .gray)
        completeLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[3])
        completeLabel.zPosition = 40
        self.nodeContainer.addChild(completeLabel)
        
        // "Score: X"
        let scoreLabel = self.normalLabel(text: "\(points) Points")
        scoreLabel.fontColor = Colors.red
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[5])
        scoreLabel.run(Actions.fadeLoop(duration: 2.0))
        self.nodeContainer.addChild(scoreLabel)
        
        // Words of encouragement
        let wordsLabel = self.normalLabel(text: WordsOfEncouragement.getRoundComplete())
        wordsLabel.fontColor = .white
        wordsLabel.alpha = 0.8
        wordsLabel.fontSize = 24
        wordsLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[6])
        self.nodeContainer.addChild(wordsLabel)
        
        // "tap to continue"
        let continueLabel = self.normalLabel(text: "Tap to continue")
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
                ]),
            Actions.fadeLoop(duration: 1.5)
            ]))
        self.nodeContainer.addChild(label)
        
        // Highscores
        let newHighscore = self.createHighscore(level: level, points: points)
        var highscores = self.loadHighscores()
        highscores.append(newHighscore)
        
        highscores = highscores.sorted(by: { $0.level > $1.level || $0.points > $1.points })
        // @TODO: Limit # of highscores
        self.saveHighscores(highscores: highscores)
        
        var shownYours = false
        let max = min(highscores.count-1, 4)
        for i in 0...max {
            var highscore = highscores[i]
            if i == max && !shownYours {
                highscore = newHighscore
            }
            let same = self.same(highscore, newHighscore)
            if same { shownYours = true }
            let highestScore = (same && i == 0)
            
            let scoreLabel = self.alignedLabel(round: highscore.level,
                                               score: highscore.points,
                                               color: same ? Colors.yellow : .white)
            scoreLabel.position = CGPoint(x: 0.0, y: layout.positions[4 + i])
            scoreLabel.alpha = 0.0
            scoreLabel.zPosition = 30
            
            if same {
                if highestScore {
                    scoreLabel.run(SKAction.sequence([
                        SKAction.wait(forDuration: Double(i+2) * 0.5),
                        SKAction.group([
                            SKAction.fadeIn(withDuration: 0.7),
                            SKAction.moveBy(x: 0.0, y: 10.0, duration: 0.7)
                            ]),
                        SKAction.run { self.scene.run(Resources.shared.getSound(.highscore)) },
                        SKAction.run {
                            let hsLabel = self.newHSLabel()
                            hsLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[3])
                            self.nodeContainer.addChild(hsLabel)
                        },
                        Actions.fadeLoop(duration: 0.4)
                        ]))
                } else {
                    scoreLabel.run(SKAction.sequence([
                        SKAction.wait(forDuration: Double(i+2) * 0.5),
                        SKAction.group([
                            SKAction.fadeIn(withDuration: 0.7),
                            SKAction.moveBy(x: 0.0, y: 10.0, duration: 0.7)
                            ]),
                        Actions.fadeLoop(duration: 0.4)
                        ]))
                }
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
        
        // Words of encouragement
        let wordsLabel = self.normalLabel(text: WordsOfEncouragement.getRoundLose())
        wordsLabel.fontColor = .white
        wordsLabel.alpha = 0.0
        wordsLabel.fontSize = 24
        wordsLabel.position = CGPoint(x: self.scene.frame.midX, y: layout.positions[9])
        wordsLabel.run(SKAction.sequence([
            SKAction.wait(forDuration: 4.0),
            SKAction.fadeAlpha(to: 0.8, duration: 1.0)]))
        self.nodeContainer.addChild(wordsLabel)
        
        // @HACK
        let continueButton = ButtonNode(color: .clear, size: self.scene.frame.size)
        continueButton.zPosition = 100 // @HARDCODED
        continueButton.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        continueButton.action = { self.delegate.addEvent(.flowControlPhaseUpdate(phase: .origin)) }
        continueButton.isUserInteractionEnabled = false
        continueButton.run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run { continueButton.isUserInteractionEnabled = true }]))
        self.nodeContainer.addChild(continueButton)
    }
    
    private func newHSLabel() -> SKLabelNode {
        let label = self.defaultLabel(text: "New Highscore!")
        label.fontColor = Colors.yellow
        label.fontSize = 20
        label.run(Actions.blink(duration: 0.2, count: 10))
        return label
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
    
    private func alignedLabel(round: Int, score: Int, color: UIColor) -> SKNode {
        let margin = self.scene.frame.width * 0.08
        
        let roundLabel = self.normalLabel(text: "Round \(round)")
        roundLabel.fontColor = color
        roundLabel.horizontalAlignmentMode = .left
        roundLabel.position = CGPoint(x: self.scene.frame.minX + margin, y: 0)
        
        let scoreLabel = self.normalLabel(text: "\(score) \(score == 1 ? "Point" : "Points")")
        scoreLabel.fontColor = color
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: self.scene.frame.maxX - margin, y: 0)
        
        let container = SKNode()
        container.addChild(roundLabel)
        container.addChild(scoreLabel)
        return container
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

class WordsOfEncouragement {
    static func getRoundComplete() -> String {
        let phrases = ["Keep going",
                       "You can do it",
                       "Believe in yourself",
                       "You must overcome",
                       "Fly!"]
        let randomIndex = RealRandom().nextInt(min: 0, max: phrases.count)
        return phrases[randomIndex]
    }
    
    static func getRoundLose() -> String {
        if RealRandom().nextInt(min: 0, max: 200000) == 151420 {
            Analytics.logEvent("poopy_di_scoop", parameters: nil)
            return "Poop-diddy, whoop-scoop"
        }
        
        let phrases = ["Lift yourself",
                       "You can suceeed",
                       "Follow your dreams",
                       "You are a champion",
                       "Fly like the wind"]
        let randomIndex = RealRandom().nextInt(min: 0, max: phrases.count)
        return phrases[randomIndex]
    }
}
