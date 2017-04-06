//
//  WebViewController.swift
//  RedditIOSClient
//
//  Created by Dario Miñones on 4/6/17.
//  Copyright © 2017 Dario Miñones. All rights reserved.
//

import UIKit
import Foundation

class WebViewController: UIViewController {
    var link : Link? = nil
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let link = self.link {
            self.title = link.title
            self.webView.loadRequest(URLRequest(url: URL(string:link.url)!))
        }
    }
}
