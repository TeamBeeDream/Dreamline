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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = EAGLContext(api: .openGLES2)
        if self.context == nil {
            print("Failed to create ES context")
        }
        
        EAGLContext.setCurrent(self.context)
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        view.drawableColorFormat = .RGBA8888
        
        glClearColor(0.0, 0.0, 0.0, 0.0)
        glClearDepthf(1.0)
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        render()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

