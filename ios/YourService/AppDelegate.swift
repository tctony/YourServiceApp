//
//  AppDelegate.swift
//  YourService
//
//  Created by changtang on 16/1/14.
//  Copyright © 2016年 TCTONY. All rights reserved.
//

import Foundation
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: UIViewController?

    static func theOne() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        var jsCodeLocation: NSURL?
        //jsCodeLocation = NSURL(string: "http://192.168.0.104:8081/index.ios.bundle?platform=ios&dev=true")
        jsCodeLocation = NSBundle.mainBundle().URLForResource("main", withExtension: "jsbundle")

        let rootView = RCTRootView(bundleURL: jsCodeLocation, moduleName: "YourService", initialProperties: nil, launchOptions: launchOptions)

        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        rootViewController = UIViewController()
        rootViewController!.view = rootView
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()

        dispatch_after(0, dispatch_get_main_queue()) { () -> Void in
            self.registerNotification(application)
            self.handleLuanchWithNotification(launchOptions)
        }
        
        return true
    }
}
