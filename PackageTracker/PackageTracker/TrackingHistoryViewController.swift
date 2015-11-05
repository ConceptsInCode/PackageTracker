//
//  TrackingHistoryViewController.swift
//  PackageTracker
//
//  Created by BJ Miller on 9/13/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import UIKit

class TrackingHistoryViewController: UIViewController {
    
    // MARK: outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackPackageTextField: UITextField!
    @IBOutlet weak var trackPackageButton: UIButton!
    
    // dependencies
    lazy var persistenceController: PersistenceController = PersistenceController(modelName: "PackageModel", storeType: .SQLite) { pvc in
        print("persistence controller created")
        NSNotificationCenter.defaultCenter().postNotificationName("core data stack created", object: nil)
    }

    var handleSelection: ((String) -> Void)?
    
    // data source 
    var items = [Package]()

    var selectedPackageID: String?
    
    // MARK: view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAndDisplayHistory()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchAndDisplayHistory", name: "CoreDataReady", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("fetchAndDisplayHistory"), name: "core data stack created", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "CoreDataReady", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "core data stack created", object: nil)
    }
    
    
    // MARK: actions
    @IBAction func trackPackage(sender: AnyObject?) {
        selectedPackageID = trackPackageTextField.text
        
        performSegueWithIdentifier("showDetail", sender: nil)
    }

    func fetchAndDisplayHistory() {
        guard let items = persistenceController.fetchAll(entity: "Package") as? [Package] else { return }
        self.items = items
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    func persistPackage(packageID: String) {
        let workerContext = WorkerContext(parent: self.persistenceController.mainContext)
        let package = workerContext.insert("Package") as! Package
        package.packageID = packageID
        workerContext.save {
            self.fetchAndDisplayHistory()
            self.persistenceController.save()
        }
    }
    
    // MARK: navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail",
//            let indexPath = tableView.indexPathForSelectedRow,
            let navVC = segue.destinationViewController as? UINavigationController,
            packageInjectable = navVC.topViewController as? PackageDependencyInjectable {
                
                guard let packageID = selectedPackageID else { return }
                
                packageInjectable.updateDetailsForPackageID(packageID) { self.persistPackage(packageID) }
                
                let vc = navVC.topViewController
                vc?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                vc?.navigationItem.leftItemsSupplementBackButton = true
        }
    }

}

extension TrackingHistoryViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") else { return UITableViewCell() }
        cell.textLabel?.text = items[indexPath.row].packageNickname
        cell.detailTextLabel?.text = items[indexPath.row].packageID
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedPackageID = items[indexPath.row].packageID
        performSegueWithIdentifier("showDetail", sender: nil)
    }
}

//extension TrackingHistoryViewController : PersistenceControllerAccessible { }

protocol PackageDependencyInjectable {
    func updateDetailsForPackageID(packageID: String, completion: Void -> Void)
}