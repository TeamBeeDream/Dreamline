//
//  AssemblyTest.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

class ToggleBuffer<T> {
    
    private var head: Int = 0
    private var buffer: [T]!
    
    static func make(value: T) -> ToggleBuffer {
        let instance = ToggleBuffer()
        instance.buffer = [T](repeating: value, count: 2)
        return instance
    }
    
    func access() -> T {
        return self.buffer[self.head]
    }
    
    func inject(_ value: T) {
        self.buffer[self.head] = value
    }
    
    func toggle() {
        if self.head == 0   { self.head = 1 }
        else                { self.head = 0 }
    }
}

class TestScene: SKScene {
    
    // MARK: Dipko
    
    var kernels: [Kernel]!
    var rules: [Rule]!
    var observers: [Observer]!
    
    // MARK: Private Properties
    
    private var previousTime: TimeInterval = 0
    private var infoLabel: SKLabelNode!
    
    private var stateBuffer = ToggleBuffer.make(value: KernelState.new())
    private var eventsBuffer = ToggleBuffer.make(value: [KernelEvent]()) // @HACK
    private var instrBuffer = ToggleBuffer.make(value: [KernelInstruction]()) // @HACK
    
    private var inputCount: Int = 0
    private var inputTarget: Int = 0
    
    // @HACK
    static let TEXT_Z_POSITION: CGFloat = 1.0
    static let LINE_Z_POSITION: CGFloat = 0.0
    
    // MARK: Init
    
    static func make(state: KernelState,
                     kernels: [Kernel],
                     rules: [Rule]) -> TestScene {
        let instance = TestScene()
        instance.kernels = kernels
        instance.rules = rules
        instance.stateBuffer.inject(state)
        return instance
    }
    
    // MARK: SKScene Methods
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .darkText
        
        // @TEMP
        self.observers = [LineRenderer.make(view: view),
                          PlayerRenderer.make(view: view)] // @HACK @HARDCODED
        
        let infoLabel = TestScene.makeInfoLabel()
        infoLabel.position = CGPoint(x: view.frame.minX, y: view.frame.maxY)
        self.infoLabel = infoLabel
        self.addChild(infoLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // @NOTE: The official update step list:
        // - Poll user/external input
        // - Calculate realtime delta time
        // - Update Kernels
        // - Update Rules
        // - Update Observers
        // - Store instructions for next update
        
        
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        // @TEMP
        var workingEvents = self.eventsBuffer.access()  // :(
        var workingState = self.stateBuffer.access()    // :(
        
        // @TEMP: Inject user input
        var instructions = self.instrBuffer.access()
        instructions.append(.updateInput(self.inputTarget))
        
        // KERNEL
        for kernel in self.kernels {
            for instr in instructions {
                kernel.mutate(state: &workingState,
                              events: &workingEvents,
                              instr: instr)
            }
        }
        
        // RULES
        self.instrBuffer.toggle()
        var newInstructions = self.instrBuffer.access()
        newInstructions.removeAll(keepingCapacity: true)// :(?
        for rule in self.rules {
            rule.mutate(state: &workingState,
                        events: &workingEvents,
                        instructions: &newInstructions,
                        deltaTime: dt)
        }
        
        // OBSERVERS
        for observer in self.observers {
            observer.observe(events: workingEvents) // @SLOW
        }

        // @ROBUST: Check memory usage around toggle buffers
        
        self.stateBuffer.toggle()
        self.stateBuffer.inject(workingState)
        
        workingEvents.removeAll()
        self.eventsBuffer.toggle()
        
        self.instrBuffer.toggle()
        self.instrBuffer.inject(newInstructions)
        
        // @TEMP @SLOW
        var infoString = ""
        infoString.append("Time\n")
        infoString.append("Tick:  \(workingState.timeState.frameNumber)\n")
        infoString.append("Time:  \(workingState.timeState.timeSinceBeginning)\n")
        infoString.append("Delta: \(workingState.timeState.deltaTime)\n")
        infoString.append("Paused:  \(workingState.timeState.paused)\n")
        infoString.append("\n")
        infoString.append("Board\n")
        infoString.append("Distance:  \(workingState.boardState.scrollDistance)\n")
        infoString.append("Count: \(workingState.boardState.entities.count)\n")

        let info = self.infoLabel!
        info.text = infoString // @SLOW!!!
    }
    
    // @TEMP
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            self.inputTarget = location.x > self.frame.midX ? 1 : -1
            self.inputCount += 1
        }
    }
    
    // @TEMP
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputCount -= touches.count
        if self.inputCount == 0 { self.inputTarget = 0 }
    }
    
    // @TEMP
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputCount -= touches.count
        if self.inputCount == 0 { self.inputTarget = 0 }
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
        label.zPosition = TestScene.TEXT_Z_POSITION
        return label
    }
}
