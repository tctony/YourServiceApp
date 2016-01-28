//
//  PresentedWebViewController.swift
//  YourService
//
//  Created by changtang on 16/1/28.
//  Copyright © 2016年 TCTONY. All rights reserved.
//

import Foundation

class PresentedWebViewController: BaseWebViewController {

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        let closeItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "onClose")
        self.navigationItem.leftBarButtonItem = closeItem
    }

    func onClose() {
        self .dismissViewControllerAnimated(true, completion: nil)
    }
}