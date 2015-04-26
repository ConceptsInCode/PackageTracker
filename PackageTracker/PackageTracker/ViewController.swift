//
//  ViewController.swift
//  PackageTracker
//
//  Created by BJ on 4/26/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import UIKit

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

