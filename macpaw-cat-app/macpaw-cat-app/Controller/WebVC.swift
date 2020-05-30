//
//  WebVC.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 21.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit
import WebKit
class WebVC: UIViewController, WKUIDelegate {
    
    private var url: String = ""
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var web: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.3992092311, green: 0.3836411536, blue: 0.2096695304, alpha: 1)
        let myURL = URL(string: self.url)
        let myRequest = URLRequest(url: myURL!)
        web.uiDelegate = self
        web.navigationDelegate = self
        web.load(myRequest)
    }
    
    
    func initVC (wikiURL url: String) {
        self.url = url
    }

}

extension WebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        activityIndicator.stopAnimating()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
}
