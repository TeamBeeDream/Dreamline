//
//  AssemblyTest.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

class TestScene: SKScene {
    
    // MARK: Dipko
    
    var state: KernelState!
    var kernels: [Kernel]!
    var rules: [Rule]!
    var observers: [Observer]!
    
    var instructions = [KernelInstruction]()
    
    // MARK: Private Properties
    
    private var previousTime: TimeInterval = 0
    private var infoLabel: SKLabelNode!
    
    // MARK: Init
    
    static func make(state: KernelState,
                     kernels: [Kernel],
                     rules: [Rule]) -> TestScene {
        let instance = TestScene()
        instance.state = state
        instance.kernels = kernels
        instance.rules = rules
        return instance
    }
    
    // MARK: SKScene Methods
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .darkText
        
        // @TEMP
        let container = SKNode()
        let lineRenderer = LineRenderer.make(frame: view.frame, container: container)
        self.observers = [lineRenderer] // @HACK
        self.addChild(container)
        
        let infoLabel = TestScene.makeInfoLabel()
        infoLabel.position = CGPoint(x: view.frame.minX, y: view.frame.maxY)
        self.infoLabel = infoLabel
        self.addChild(infoLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        // Trigger kernel update
        var partialState = KernelState.clone(self.state)
        var raisedEvents = [KernelEvent]()
        for kernel in self.kernels {
            let (state, events) = kernel.update(state: partialState,
                                                instructions: self.instructions)
            partialState = state
            raisedEvents.append(contentsOf: events)
        }
        
        // Trigger protocol update
        var raisedInstructions = [KernelInstruction]()
        for rule in self.rules {
            let (_, instructions) = rule.process(state: partialState,
                                                 events: raisedEvents,
                                                 deltaTime: dt)
            raisedInstructions.append(contentsOf: instructions)
        }
        
        // Trigger observer update
        for observer in self.observers {
            observer.observe(events: raisedEvents)
        }
        
        // Store for next tick
        self.state = partialState
        self.instructions = raisedInstructions
        
        // @TEMP
        var infoString = ""
        infoString.append("Time\n")
        infoString.append("Tick:  \(self.state.timeState.frameNumber)\n")
        infoString.append("Time:  \(self.state.timeState.timeSinceBeginning)\n")
        infoString.append("Delta: \(self.state.timeState.deltaTime)\n")
        infoString.append("Paused:  \(self.state.timeState.paused)\n")
        infoString.append("\n")
        infoString.append("Board\n")
        infoString.append("Distance:  \(self.state.boardState.scrollDistance)\n")
        infoString.append("Count: \(self.state.boardState.entities.count)\n")
        
        if !self.state.boardState.entities.isEmpty {
            infoString.append("\n")
            for entity in self.state.boardState.entities {
                infoString.append("\(entity.id) - Y: \(entity.position)\n")
            }
        }
        
        let info = self.infoLabel!
        info.text = infoString
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.state.timeState.paused {
            self.instructions.append(.unpause)
        } else {
            self.instructions.append(.pause)
        }
    }
    
    // MARK: Private Methods
    
    private static func makeInfoLabel() -> SKLabelNode {
        let label = SKLabelNode()
        label.fontColor = .white
        label.fontSize = 20.0
        label.fontName = "Avenir-Medium"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .top
        return label
    }
}
