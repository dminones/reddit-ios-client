//
//  Link.swift
//  RedditIOSClient
//
//  Created by Dario Miñones on 4/4/17.
//  Copyright © 2017 Dario Miñones. All rights reserved.
//

import Foundation

class Link: NSObject, NSCoding {
    let title: String
    let author: String
    let thumbnail: String?
    var imageUrl: String?
    let createdUTC: NSDate
    let numComments: Int?
    
    //MARK: NSCoding protocol methods
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.thumbnail, forKey: "thumbnail")
        aCoder.encode(self.imageUrl, forKey: "imageUrl")
        aCoder.encode(self.createdUTC, forKey: "createdUTC")
        aCoder.encode(self.numComments, forKey: "numComments")
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObject(forKey: "title") as! String
        self.author = decoder.decodeObject(forKey: "author") as! String
        self.thumbnail = decoder.decodeObject(forKey: "thumbnail") as? String
        self.imageUrl = decoder.decodeObject(forKey: "imageUrl") as? String
        self.createdUTC = (decoder.decodeObject(forKey: "createdUTC") as? NSDate)!
        self.numComments = decoder.decodeObject(forKey: "numComments") as? Int
    }
    
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

