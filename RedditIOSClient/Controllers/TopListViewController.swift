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
    var links : [Link] = []
    // cell reuse id (cells that scroll out of view can be reused)
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Top"
        self.tableView.estimatedRowHeight = 80;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.setLoadingScreen()
        self.loadData()
        
        self.refreshControl?.addTarget(self, action: #selector(TopListViewController.handleRefresh(sender:)), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.refreshControl?.beginRefreshing()
    }
    
    func handleRefresh(sender:UIRefreshControl) {
        self.loadData(sender: sender)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LinkTableViewCell
        
        cell.link = self.links[indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    
    // MARK: Private methods
    
    // Load data in the tableView
    private func loadData(sender: UIRefreshControl? = nil) {
        
        let redditClient = RedditApiClient()
        redditClient.getTopLinks(successHandler: {(links) in
            self.links = links
            DispatchQueue.main.async() {
                self.tableView.reloadData()
                if let refreshControl = sender {
                    refreshControl.endRefreshing()
                }
                self.removeLoadingScreen()
            }
        })
        
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {

        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x:x, y:y,width:width,height: height)
        
        // Sets loading text
        self.loadingLabel.textColor = UIColor.gray
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Loading..."
        self.loadingLabel.frame = CGRect(x:0, y:0, width:140, height:30)
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.spinner.frame = CGRect(x:0, y:0, width:30, height:30)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableView.addSubview(loadingView)
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        self.tableView.separatorStyle = .singleLine
        
        // Hides and stops the text and the spinner
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
    }
}

