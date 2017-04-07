//
//  Link.swift
//  RedditIOSClient
//
//  Created by Dario Miñones on 4/4/17.
//  Copyright © 2017 Dario Miñones. All rights reserved.
//

import Foundation

struct Link {
    let title: String
    let author: String
    let thumbnail: String?
    var imageUrl: String?
    let createdUTC: NSDate
    let numComments: Int
}

extension Link {
    init?(json: [String: Any]) {
        let jsonData = json["data"] as? [String: Any]
        guard let title = jsonData?["title"] as? String,
            let author = jsonData?["author"] as? String,
            let thumbnail = jsonData?["thumbnail"] as? String,
            let createdUTC = jsonData?["created_utc"] as? Int,
            let numComments = jsonData?["num_comments"] as? Int
            else {
                return nil
        }
        
        if let preview = jsonData?["preview"] as! [String: Any]?{
            //print("preview \(preview)")
            if let images = (preview["images"] as! [Any]?){
                let image = images.first as! [String: Any]?
                if let source = image?["source"] as! [String:Any]? {
                    self.imageUrl = source["url"] as? String
                }
            }
        }
        
        self.title = title
        self.author = author
        self.thumbnail = thumbnail
        self.createdUTC = NSDate(timeIntervalSince1970: Double(createdUTC))
        self.numComments = numComments
    }
}
