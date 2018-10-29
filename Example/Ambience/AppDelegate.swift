//
//  AppDelegate.swift
//  Ambience
//
//  Created by tmergulhao on 12/15/2017.
//  Copyright (c) 2017 tmergulhao. All rights reserved.
//

import UIKit
import Ambience

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = Ambience.shared
        
        return true
    }
}
