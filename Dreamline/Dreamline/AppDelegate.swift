//
//  AppDelegate.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Private Properties
    
    var window: UIWindow?

    // MARK: UIApplicationDelegate Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // @TODO: Properly setup Firebase
        //FirebaseApp.configure()
        
        Resources.shared.preload()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = DreamlineViewController.make()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

