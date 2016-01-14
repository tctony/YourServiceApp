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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        var jsCodeLocation: NSURL?
        jsCodeLocation = NSURL(string: "http://localhost:8081/index.ios.bundle?platform=ios&dev=true");
        //jsCodeLocation = NSBundle.mainBundle().URLForResource("main", withExtension: "jsbundle");

        let rootView = RCTRootView(bundleURL: jsCodeLocation, moduleName: "YourService", initialProperties: nil, launchOptions: launchOptions)

        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        let rootViewController = UIViewController();
        rootViewController.view = rootView;
        self.window!.rootViewController = rootViewController;
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
    
}