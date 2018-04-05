//
//  BarrierNode.swift
//  Dreamline
//
//  Created by BeeDream on 3/8/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

class BarrierNode: SKNode {
    
    let layout: BoardLayout
    var boardWidth: Double
    var graphic: SKNode?
    var bits: [SKShapeNode]
    
    init(layout: BoardLayout, width: Double) {
        
        self.layout = layout
        self.boardWidth = width
        self.bits = [SKShapeNode]()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // @TODO: Move to separate class (in graphics folder)
    // @RENAME: Imply that this should be called before using it
    func drawOnce(barrier: Barrier, status: EntityStatus) {
        
        // @CLEANUP: This code is hard to understand
        let occupied = 1.0 - self.layout.laneOffset * 2
        let margin = (self.boardWidth * occupied) / 2.0
        let width = self.boardWidth - (margin * 2.0)
        let gateWidth = Double(width / 4.0)
//        let gateHeight = 20.0 // @HARDCODED
        let wallY: Double = 0
        
        let barrierGraphic = SKNode()
        let wallColor = self.wallColor()
        
        let data = self.barrierDataToBoolArray(data: barrier.gates)
        for i in 1...4 {
            let prev = data[i-1]
            let curr = data[i]
            
            let prevX: Double = Double(i-1) * gateWidth + Double(margin)
            let currX: Double = Double(i) * gateWidth + Double(margin)
            let midX: Double = (prevX + currX) / 2.0
            if !prev {
                let wall = self.createLine(from: CGPoint(x: prevX, y: wallY),
                                           to: CGPoint(x: midX, y: wallY),
                                           color: wallColor)
                barrierGraphic.addChild(wall)
                self.bits.append(wall)
            }
            if !curr {
                let wall = self.createLine(from: CGPoint(x: midX, y: wallY),
                                           to: CGPoint(x: currX, y: wallY),
                                           color: wallColor)
                barrierGraphic.addChild(wall)
                self.bits.append(wall)
            }
        }
        
        self.graphic = barrierGraphic
        addChild(self.graphic!)
    }
    
    // @TODO: Colors should be gotten from a common palette data structure
    private func wallColor() -> SKColor {
        return SKColor(red: 43.0/255.0, green: 54.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    private func barrierDataToBoolArray(data: [Gate]) -> [Bool] {
        assert(data.count == 3) // @ROBUSTNESS: expects data array to have exactly 3 values
        var result = [Bool](repeating: false, count: 5)
        result[0] = false
        result[4] = false
        for (i, value) in data.enumerated() {
            switch (value) {
            case .open:   result[i+1] = true
            case .closed: result[i+1] = false
            }
        }
        return result
    }
    
    // @TODO: Move to common graphics class
    private func createLine(from: CGPoint,
                            to: CGPoint,
                            color: SKColor,
                            width: CGFloat = 2.0) -> SKShapeNode {
        
        let node = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        node.path = path.cgPath
        node.strokeColor = color
        node.lineWidth = width
        node.lineCap = .round
        node.isAntialiased = true // @HARDCODED
        return node
    }
}
