//
//  AppDelegate.swift
//  Pong
//
//  Created by Jonathan Bijos on 21/07/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let gameViewController = GameViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = gameViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

