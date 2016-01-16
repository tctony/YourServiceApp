//
//  NotificationHandler.swift
//  YourService
//
//  Created by Tony Tang on 16/1/16.
//  Copyright © 2016年 TCTONY. All rights reserved.
//

import Foundation

extension UIUserNotificationAction {

    static var close: UIUserNotificationAction {
        get {
            let action = UIMutableUserNotificationAction()
            action.identifier = "close"
            action.title = "关闭"
            action.activationMode = .Background
            action.authenticationRequired = false
            action.destructive = false
            if #available(iOS 9.0, *) {
                action.behavior = .Default
                action.parameters = [:]
            }

            return action
        }
    }

    static var later: UIUserNotificationAction {
        get {
            let action = UIMutableUserNotificationAction()
            action.identifier = "later"
            action.title = "稍后"
            action.activationMode = .Background
            action.authenticationRequired = false
            action.destructive = false
            if #available(iOS 9.0, *) {
                action.behavior = .Default
                action.parameters = [:]
            }

            return action
        }
    }

    static var view: UIUserNotificationAction {
        get {
            let action = UIMutableUserNotificationAction()
            action.identifier = "view"
            action.title = "查看"
            action.activationMode = .Foreground
            action.authenticationRequired = false
            action.destructive = false
            if #available(iOS 9.0, *) {
                action.behavior = .Default
                action.parameters = [:]
            }

            return action
        }
    }

    static var jump: UIUserNotificationAction {
        get {
            let action = UIMutableUserNotificationAction()
            action.identifier = "jump"
            action.title = "跳转"
            action.activationMode = .Foreground
            action.authenticationRequired = false
            action.destructive = false
            if #available(iOS 9.0, *) {
                action.behavior = .Default
                action.parameters = [:]
            }

            return action
        }
    }
}

extension UIUserNotificationCategory {

    static var uri: UIUserNotificationCategory {
        get {
            let category = UIMutableUserNotificationCategory()
            category.identifier = "uri"
            category.setActions([ .close, .later, .jump ], forContext: .Default)
            category.setActions([ .close, .jump ], forContext: .Minimal)

            return category
        }
    }
}

class NotificationHandler {

    static let sharedInstance = NotificationHandler()
}

extension AppDelegate {
    func registerNotification(application: UIApplication) {
        let types: UIUserNotificationType = [ .Badge, .Sound, .Alert ]

        let categories = Set<UIUserNotificationCategory>(arrayLiteral: .uri)

        let settings = UIUserNotificationSettings(forTypes: types, categories: categories)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token = deviceToken.description
            .stringByReplacingOccurrencesOfString("<", withString: "")
            .stringByReplacingOccurrencesOfString(" ", withString: "")
            .stringByReplacingOccurrencesOfString(">", withString: "")

        print("get push token: \(token)")
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("get token failed: \(error)")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("get push with userinfo \(userInfo)")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("get push with userinfo: \(userInfo)\n  and handler: \(completionHandler)")

        // TODO alert and jump

        completionHandler(.NoData)
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("get push from action \(identifier)\n with userinfo: \(userInfo)\n and handler: \(completionHandler)")

        if identifier == UIUserNotificationAction.jump.identifier {
            if let uri = userInfo["uri"] as? String, let url = NSURL(string: uri) {
                print("open url: ", url)
                application.openURL(url)
            }
        }

        completionHandler()
    }
}
