//
//  TrackingHistoryViewController.swift
//  PackageTracker
//
//  Created by BJ Miller on 9/13/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import UIKit

class TrackingHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // dependencies
    var persistenceController: PersistenceController!
    var handleSelection: ((String) -> Void)?
    
    // data source 
    var items = [Package]()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAndDisplayHistory()
    }

    func fetchAndDisplayHistory() {
        guard let items = persistenceController?.fetchAll(entity: "Package") as? [Package] else { return }
        self.items = items
        tableView.reloadData()
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
        let packageID = items[indexPath.row].packageID ?? ""
        dismissViewControllerAnimated(true, completion: { handleSelection?(packageID) })
    }
}
