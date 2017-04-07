//
//  WebViewController.swift
//  RedditIOSClient
//
//  Created by Dario Miñones on 4/6/17.
//  Copyright © 2017 Dario Miñones. All rights reserved.
//

import UIKit
import Foundation
import AssetsLibrary
import Photos

class WebViewController: UIViewController {
    var url : String?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))

        if let url = self.url {
            print("image \(url)")
            self.webView.loadRequest(URLRequest(url: URL(string:url)!))
        }
    }
    
    func showSimpleAlert (_ title:String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTapped() {
        print("Add tapped")
        if let url = self.url {
            URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    self.showSimpleAlert("Can't save image")
                    return
                }
                
                PHPhotoLibrary.requestAuthorization({(status) in
                    if status == .authorized {
                        let image = UIImage(data: data!)
                        PHPhotoLibrary.shared().performChanges({
                            _ = PHAssetChangeRequest.creationRequestForAsset(from: image!)
                        }, completionHandler: { (success, error) in
                            if success {
                                self.showSimpleAlert("Photo saved to device!")
                            }
                            else {
                                self.showSimpleAlert("Can't save image")
                            }
                        })
                    } else {
                        self.showSimpleAlert("Can't save image", message:"You should authorize photos access to the app from settings")
                    }
                })
                
            }).resume()
        }
    }
}
