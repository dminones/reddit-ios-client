//
//  RedditApiClient.swift
//  RedditIOSClient
//
//  Created by Dario Miñones on 4/5/17.
//  Copyright © 2017 Dario Miñones. All rights reserved.
//

import Foundation

class RedditApiClient {
    static let url = "https://oauth.reddit.com"
    static let userAgent = "iOS Reddit Client by dminones"
    
    private let clientId : String
    private let secret : String
    private let deviceId: String
   
    private var accessToken: String?{
        get {
            return (UserDefaults.standard.object(forKey: "access_token") as? String?)!
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "access_token")
            defaults.synchronize()
        }
    }
    
    private var expires: Date?{
        get {
            return (UserDefaults.standard.object(forKey: "expires") as? Date?)!
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "expires")
            defaults.synchronize()
        }
    }
    
    private var tokenType: String?{
        get {
            return (UserDefaults.standard.object(forKey: "token_type") as? String?)!
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "token_type")
            defaults.synchronize()
        }
    }
    
    init() {
        self.clientId = "ywRkiJsL1jOVng"
        self.secret = "HAjlUZzfM-uryjz7Wt111ZUoJ6Q"
        self.deviceId = "DO_NOT_TRACK_THIS_DEVICE"
    }
    
    func authorized() -> Bool {
        return (self.accessToken != nil) && (self.expires != nil) && (self.expires! > Date());
    }
    
    func authorize(successHandler: @escaping () -> Swift.Void) {
        //If already authorized and token not expired shouldn't ask for a new token
        if(self.authorized()) {
            successHandler()
            return
        }
        
        var request = URLRequest(url: URL(string: "https://www.reddit.com/api/v1/access_token")!)
        
        let loginString = String(format: "%@:%@", self.clientId, self.secret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // create the request
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let postString = "grant_type=https://oauth.reddit.com/grants/installed_client&device_id=\(self.deviceId)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            do {
                let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                NSLog("jsonResult %@",jsonResult)
                if let accessToken = jsonResult["access_token"] {
                    self.accessToken = accessToken as? String
                }
                if let tokenType = jsonResult["token_type"] {
                    self.tokenType = tokenType as? String
                }
                if let expiresIn = jsonResult["expires_in"] {
                    let calendar = Calendar.current
                    self.expires = calendar.date(byAdding: .second, value: expiresIn as! Int, to: Date())
                }
                successHandler()
            } catch {
                print("Cannot parse response")
            }
            
           
            return
        }
        task.resume()
    }
    
    func getTopLinks (successHandler: @escaping ([Link]) -> Swift.Void) {
        var links : [Link] = []
        
        self.authorize(successHandler: { () in
            var request = URLRequest(url: URL(string: "\(RedditApiClient.url)/top.json")!)
            request.httpMethod = "GET"
            request.addValue("\(self.tokenType!) \(self.accessToken!)", forHTTPHeaderField: "Authorization")
            request.addValue(RedditApiClient.userAgent, forHTTPHeaderField: "User-Agent")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if let data : NSDictionary = jsonResult["data"] as? NSDictionary {
                        if let children : [NSDictionary] = data["children"] as? [NSDictionary] {
                            for item in children {
                                if  let link = Link(json: item as! [String : Any]) {
                                    links.append(link)
                                }
                            }
                            successHandler(links)
                        }
                    }
                } catch {}
                return
            }
            task.resume()
        })
    }
}
