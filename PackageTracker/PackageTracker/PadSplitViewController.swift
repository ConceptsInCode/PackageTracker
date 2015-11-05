//
//  PadSplitViewController.swift
//  PackageTracker
//
//  Created by BJ Miller on 10/20/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import UIKit

class PadSplitViewController: UISplitViewController {
    func setPersistenceControllerForMasterViewController(pvc: PersistenceController) {
        guard let nav = viewControllers.first as? UINavigationController,
            var master = nav.topViewController as? PersistenceControllerAccessible else { return }
        master.persistenceController = pvc
    }
    
    func fetchPackageInfo(packageID packageID: String) {
        guard let detail = viewControllers.last as? ViewController else { return }
        detail.fetchPackageInfo(packageID: packageID)
    }
}
