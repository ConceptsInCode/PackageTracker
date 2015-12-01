//
//  AppDelegate.swift
//  PackageTracker
//
//  Created by BJ on 4/26/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navController = splitViewController.viewControllers.last as! UINavigationController
        navController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        return true
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let _ = secondaryAsNavController.topViewController as? ViewController else { return false }
            return true
    }
}

