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
    
    lazy var persistenceController: PersistenceController = PersistenceController(modelName: "PackageModel", storeType: .SQLite) { pvc in
        print("persistence controller created")
        NSNotificationCenter.defaultCenter().postNotificationName("core data stack created", object: nil)
    }


    var items = [String]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackingTextField: UITextField!
    @IBOutlet weak var trackPackageButton: UIButton!
    @IBOutlet weak var showHistoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHistoryButton?.setImage(UIImage(named: "disabledClock"), forState: .Disabled)
        showHistoryButton?.enabled = false
        
//        let allObjects = persistenceController.fetchAll(entity: "Package")
//        print("all objects: \(allObjects.count)")
        _ = persistenceController // instantiates lazy property
        
//        splitViewController?.viewControllers.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateUI:"), name: "core data stack created", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "core data stack created", object: nil)
    }

    @IBAction func trackPackageTapped(sender: UIButton) {
        guard let text = trackingTextField.text where !text.isEmpty else { return }
        
        trackingTextField.resignFirstResponder()
        
        guard let filePath = NSBundle.mainBundle().pathForResource("USPSConfig", ofType: "jsn") else {
            let mockRequestInfo = USPSRequestInfo(userID: "steve", packageID: "123")
            USPSManager.fetchPackageResults(mockRequestInfo) { items in
                self.items = ["There is nothing to track"]
                self.tableView.reloadData()
            }
            return
        }
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
            self.postCoreDataReady()
        }
    }
    
    @IBAction func showHistory(sender: AnyObject?) {
        performSegueWithIdentifier("showHistorySegue", sender: nil)
    }
    
    private func parse(data: NSData) -> Info {
        let xmlParser = NSXMLParser(data: data)
        let packageInfo = Info()
        xmlParser.delegate = packageInfo
        xmlParser.parse()
        
        return packageInfo
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
        
        let split = splitViewController as? PadSplitViewController
        split?.setPersistenceControllerForMasterViewController(persistenceController)
        
        let packages = persistenceController.fetchAll(entity: "Package")
        showHistoryButton?.enabled = (packages.count > 0)

        postCoreDataReady()
    }
    
    private func postCoreDataReady() {
        NSNotificationCenter.defaultCenter().postNotificationName("CoreDataReady", object: nil)
    }
    
    private func userIDFromJSON() -> String? {
        guard let filePath = NSBundle.mainBundle().pathForResource("USPSConfig", ofType: "json") else { return nil }
        let data = NSData(contentsOfFile: filePath)!
        let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let userID = json["userID"] as! String
        return userID
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHistorySegue", let destinationVC = segue.destinationViewController as? TrackingHistoryViewController {
            destinationVC.persistenceController = persistenceController
            destinationVC.handleSelection = { [weak self] packageID in
                self?.fetchPackageInfo(packageID: packageID)
            }
        }
    }
    
    func fetchPackageInfo(packageID packageID: String) {
        guard let userID = userIDFromJSON() else {
            self.items = ["There's nothing to see here"]
            self.tableView?.reloadData()
            return
        }
        let requestInfo = USPSRequestInfo(userID: userID, packageID: packageID)
        USPSManager.fetchPackageResults(requestInfo) { [weak self] items in
            self?.items = items
            self?.tableView.reloadData()
        }
    }

}

extension ViewController : PackageDependencyInjectable {
    func updateDetailsForPackageID(packageID: String) {
        fetchPackageInfo(packageID: packageID)
    }
}

