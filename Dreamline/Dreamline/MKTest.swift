//
//  MetalDelegate.swift
//  Dreamline
//
//  Created by BeeDream on 3/21/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import MetalKit

class MKTest: MTKView, MTKViewDelegate {
    
    var commandQueue: MTLCommandQueue?
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        
        self.preferredFramesPerSecond = 60 // @HARDCODED
        self.delegate = self
        
        let vertexData: [Float] = [
            0.0,  1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0
        ]
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device!.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
        
        let defaultLibrary = device!.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! device!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = device!.makeCommandQueue()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // @TODO
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }
        
        // Do I have to do this once per call or just once per frame?
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        let commandBuffer = commandQueue?.makeCommandBuffer()
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(pipelineState!)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
