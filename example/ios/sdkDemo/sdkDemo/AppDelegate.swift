//
//  AppDelegate.swift
//  sdkDemo
//
//  Created by Wide Technologies Indonesia, PT on 24/03/22.
//

import UIKit
import widekyc

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            
        WKYC.sharedInstance.configure(application)
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return WKYC.sharedInstance.application(application, supportedInterfaceOrientationsFor: window)
    }
}
