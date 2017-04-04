//
//  ViewController.swift
//  Teting
//
//  Created by Dario Miñones on 4/4/17.
//  Copyright © 2017 Dario Miñones. All rights reserved.
//

import UIKit
import Foundation

class TopListViewController: UITableViewController {
    var links : [NSDictionary] = []
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Top"
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        
        //Get top links from file
        if let path = Bundle.main.path(forResource: "top", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    NSLog("json result: %@",jsonResult)
                    if let data : NSDictionary = jsonResult["data"] as? NSDictionary {
                        if let children : [NSDictionary] = data["children"] as? [NSDictionary] {
                            links = children
                            NSLog("children %@", links)
                        }
                    }
                } catch {}
            } catch {}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.links.count
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        let link = self.links[indexPath.row] as NSDictionary
        let linkData = link["data"] as! NSDictionary!
        
        cell.textLabel?.text = linkData?["title"] as? String
        
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

}

