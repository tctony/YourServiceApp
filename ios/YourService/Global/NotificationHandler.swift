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
            category.setActions([ .close, .view ], forContext: .Default)
            category.setActions([ .close, .view ], forContext: .Minimal)

            return category
        }
    }
}

class NotificationInfo {

    var alert: String?
    var badge: Int?
    var sound: String?
    var contentAvaliable: Int?
    var category: String?

    var uri: String?

    convenience init(_ userInfo: [NSObject : AnyObject]) {
        self.init()

        if let aps = userInfo["aps"] as? [String : AnyObject] {
            alert = aps["alert"] as? String
            badge = aps["badge"] as? Int
            sound = aps["sound"] as? String
            contentAvaliable = aps["content-available"] as? Int
            category = aps["category"] as? String

            uri = userInfo["uri"] as? String
        }
    }
}

class NotificationHandler {

    static let sharedInstance = NotificationHandler()

    func onReceive(info: NotificationInfo) {
        if UIApplication.sharedApplication().applicationState == .Active {
            let alertController = UIAlertController(title: nil, message: info.alert, preferredStyle: .Alert)
            let closeAction = UIAlertAction(title: UIUserNotificationAction.close.title, style: .Default, handler: nil)
            
            if info.category != nil {
                let viewAction = UIAlertAction(title: UIUserNotificationAction.view.title, style: .Default, handler: { (UIAlertAction) -> Void in
                    self.onAction(UIUserNotificationAction.view.identifier!, info: info, completionHandler: nil)
                })
                alertController.addAction(viewAction)
                alertController.addAction(closeAction)
            } else {
                alertController.addAction(UIAlertAction(title: UIUserNotificationAction.close.title, style: .Default, handler: nil))
            }
            
            NavigationCenter.presentController(alertController)
        } else {
            onAction(UIUserNotificationAction.view.identifier!, info: info, completionHandler: nil)
        }
    }

    func onProceed(info: NotificationInfo) {
        onAction(UIUserNotificationAction.view.identifier!, info: info, completionHandler: nil)
    }

    func onAction(identifier: String, info: NotificationInfo, completionHandler: (() -> Void)?) {

        switch identifier {

        case UIUserNotificationAction.view.identifier!:
            let webViewController = PresentedWebViewController()
            webViewController.pageUrl = info.uri
            NavigationCenter.presentController(webViewController, wrapInNavigationController: true)

        default:
            break
        }

        if completionHandler != nil {
            completionHandler!()
        }
    }
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

        log.info("get push token: \(token)")
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        log.info("get token failed: \(error)")
    }

    func handleLuanchWithNotification(launchOptions: [NSObject: AnyObject]?) {
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject] {
            log.info("launch on push with userInfo: \(userInfo)")

            NotificationHandler.sharedInstance.onProceed(NotificationInfo.init(userInfo))
        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        log.info("get push with userInfo: \(userInfo)")

        NotificationHandler.sharedInstance.onReceive(NotificationInfo.init(userInfo))
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        log.info("get push from action: (identifier)\nwith userInfo: (userInfo)\nand handler: (completionHandler)")

        NotificationHandler.sharedInstance.onAction(identifier ?? "", info: NotificationInfo.init(userInfo), completionHandler: completionHandler)
    }
}
