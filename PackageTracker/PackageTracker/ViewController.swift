//
//  ViewController.swift
//  PackageTracker
//
//  Created by BJ on 4/26/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    lazy var persistenceController: PersistenceController = PersistenceController(modelName: "PackageModel", storeType: .SQLite) {
        print("persistence controller created")
        NSNotificationCenter.defaultCenter().postNotificationName("core data stack created", object: nil)
    }


    var items = [String]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackingTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        persistenceController.mainContext
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateUI:"), name: "core data stack created", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "core data stack created", object: nil)
    }

    @IBAction func trackPackageTapped(sender: UIButton) {
        
        trackingTextField.resignFirstResponder()
        
        let filePath = NSBundle.mainBundle().pathForResource("USPSConfig", ofType: "json")!
        let data = NSData(contentsOfFile: filePath)!
        let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let userID = json["userID"] as! String
        let packageID = trackingTextField.text ?? ""
        let requestInfo = USPSRequestInfo(userID: userID, packageID: packageID)
        
        let workerContext = WorkerContext(parent: persistenceController.mainContext)
        let package = workerContext.insert("Package") as! Package
        package.packageID = requestInfo.packageID
        workerContext.save { () -> Void in
            print("i saved!")
        }

        USPSManager.fetchPackageResults(requestInfo) { (items: [String]) -> Void in
            self.items = items
            self.tableView.reloadData()
            self.persistenceController.save()
        }
    }
    
    private func parse(data: NSData) -> Info {
        let xmlParser = NSXMLParser(data: data)
        let packageInfo = Info()
        xmlParser.delegate = packageInfo
        xmlParser.parse()
        
        return packageInfo
    }
    
    private func updateUI(info: Info) {
        items = info.details.map { $0.event }
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PackageStatusLineCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func updateUI(notification: NSNotification) {
        let fetchRequest = NSFetchRequest(entityName: "Package")
        let context = persistenceController.mainContext
        let objects = try! context.executeFetchRequest(fetchRequest)
        print("objects count: \(objects.count)")
    }

}

