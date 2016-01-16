//
//  Ext-Foundation.swift
//  YourService
//
//  Created by Tony Tang on 16/1/16.
//  Copyright © 2016年 TCTONY. All rights reserved.
//

import Foundation

public class AppInfo {

    public static var bundleId: String {
        get {
            return NSBundle.mainBundle().bundleIdentifier!
        }
    }
}
