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
    
    func updateCell(link: Link) {
        self.title?.text = link.title
        self.subtitle?.text = "posted \(timeAgoSince(link.createdUTC as Date)) by \(link.author)"
        self.comments?.text = "\(String(describing: link.numComments)) comments"
        
        if let thumbnail = link.thumbnail {
            self.thumbnail?.downloadedFrom(link: thumbnail)
        }
    }
    
    var link : Link? {
        didSet {
            self.updateCell(link: self.link!)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let link = self.link {
            self.updateCell(link: link)
        }
    }
    
    //MARK: NSCoding protocol methods
    override func encode(with aCoder: NSCoder){
        aCoder.encode(self.link, forKey: "link")
    }
    
    required init(coder decoder: NSCoder) {
        self.link = decoder.decodeObject(forKey: "link") as? Link
        super.init(coder: decoder)!
    }
}
