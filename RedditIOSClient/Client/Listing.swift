//
//  Listing.swift
//  RedditIOSClient
//
//  Created by Dario Miñones on 4/5/17.
//  Copyright © 2017 Dario Miñones. All rights reserved.
//

import Foundation

class Listing: NSObject, NSCoding {

    var before: String?
    var after: String?
    var children = [Link]()
    
    override init(){
       super.init()
    }
    
    //MARK: NSCoding protocol methods
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.before, forKey: "before")
        aCoder.encode(self.after, forKey: "after")
        aCoder.encode(self.children, forKey: "children")
    }
    
    required init(coder decoder: NSCoder) {
        
        if let before = decoder.decodeObject(forKey: "before") as? String{
            self.before = before
        }
        if let after = decoder.decodeObject(forKey: "after") as? String{
            self.after = after
        }
        if let children = decoder.decodeObject(forKey: "children") as? [Link]{
            self.children = children
        }
    }
    
    init?(json: [String: Any]) {
        
        if let after = json["after"] as? String? {
            self.after = after
        }
        if let before = json["before"] as? String? {
            self.before = before
        }
        
        
        if let children : [NSDictionary] = json["children"] as? [NSDictionary] {
            var links = [Link]()
            for item in children {
                if  let link = Link(json: item as! [String : Any]) {
                    links.append(link)
                }
            }
            self.children = links
        }
    }
    
    func addAfter(_ after: Listing) {
        self.after = after.after
        self.children.append(contentsOf: after.children)
    }
}

