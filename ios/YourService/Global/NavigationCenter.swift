//
//  NavigationCenter.swift
//  YourService
//
//  Created by changtang on 16/1/28.
//  Copyright © 2016年 TCTONY. All rights reserved.
//

import Foundation

class NavigationCenter {

    static func presentController(controller: UIViewController) {
        presentController(controller, wrapInNavigationController: false)
    }

    static func presentController(controller: UIViewController, wrapInNavigationController wrapIn: Bool) {

        if let rootViewController = AppDelegate.theOne().rootViewController {

            if (rootViewController.presentedViewController != nil) {
                rootViewController.dismissViewControllerAnimated(false, completion: nil)
            }

            var controllerToPresent = controller
            if wrapIn {
                controllerToPresent = UINavigationController(rootViewController: controller)
            }

            rootViewController.presentViewController(controllerToPresent, animated: true, completion: nil)
        }
    }
}