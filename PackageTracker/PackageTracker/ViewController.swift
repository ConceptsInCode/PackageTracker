//
//  ViewController.swift
//  PackageTracker
//
//  Created by BJ on 4/26/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource {
    
    var items = [String]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackingTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        items = ["a", "b", "c"]
    }


    @IBAction func trackPackageTapped(sender: UIButton) {
        
        trackingTextField.resignFirstResponder()
        
        let filePath = NSBundle.mainBundle().pathForResource("USPSConfig", ofType: "json")!
        let data = NSData(contentsOfFile: filePath)!
        let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil)!
        let userID = json["userID"] as! String
        let packageID = trackingTextField.text
        let requestInfo = USPSRequestInfo(userID: userID, packageID: packageID)
        let url = requestInfo.requestURL
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { data, response, error in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    println("i'm ok")
                    let info = self.parse(data)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.updateUI(info)
                    }
                default:
                    println("i'm not okaaaaaay")
                }
            }
        }
            
        task.resume()
    }
    
    private func parse(data: NSData) -> Info {
        let xmlParser = NSXMLParser(data: data)
        let packageInfo = Info()
        xmlParser.delegate = packageInfo
        let parsed = xmlParser.parse()
        
        return packageInfo
    }
    
    private func updateUI(info: Info) {
        items = info.details.map { $0.event }
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PackageStatusLineCell") as! UITableViewCell
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

}

