//
//  BaseWebViewController.swift
//  YourService
//
//  Created by changtang on 16/1/28.
//  Copyright © 2016年 TCTONY. All rights reserved.
//

import Foundation
import WebKit

class BaseWebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var pageUrl: String?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        webView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        view.addSubview(webView)

        loadRequest()
    }

    func loadRequest() {
        if let urlString = pageUrl, url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)
            webView.loadRequest(request)

            log.info("loading page of url: \(pageUrl)")
        } else {
            log.info("failed to load: \(pageUrl)")
        }
    }

    // MARK: - WKNavigationDelegate
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

    }

}
