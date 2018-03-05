//
//  ViewController.swift
//  Dreamline
//
//  Created by BeeDream on 2/28/18.
//  Copyright © 2018 BeeDream. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {
    var context: EAGLContext? = nil
    
    var controller = TestController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = EAGLContext(api: .openGLES3)
        if self.context == nil {
            print("Failed to create ES context")
        }
        
        EAGLContext.setCurrent(self.context)
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        view.drawableColorFormat = .RGBA8888
        
        print("GLVIEW created");
        controller.setup()
        //print(view.frame.size.width, view.frame.size.height)
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // I guess this will work as the main update loop.
        self.controller.mainLoop()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let pos = t.location(in: self.view)
            self.controller.addInput(input: pos.x < 0.5 ? -1.0 : 1.0)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            self.controller.removeInput()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            self.controller.removeInput()
        }
    }
}

