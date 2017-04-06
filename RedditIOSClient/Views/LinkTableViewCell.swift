//
//  UITableViewCellLink.swift
//  RedditIOSClient
//
//  Created by Dario Miñones on 4/4/17.
//  Copyright © 2017 Dario Miñones. All rights reserved.
//

import UIKit

class LinkTableViewCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var comments: UILabel!
    
    var link : Link? {
        didSet {
            let link = self.link!
            
            self.title?.text = link.title
            self.subtitle?.text = "posted \(timeAgoSince(link.createdUTC as Date)) by \(link.author)"
            self.comments?.text = "\(link.numComments) comments"
            
            if let thumbnail = link.thumbnail {
                self.thumbnail?.downloadedFrom(link: thumbnail)
            }
        }
    }
}
