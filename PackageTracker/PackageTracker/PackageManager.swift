//
//  PackageManager.swift
//  PackageTracker
//
//  Created by Joe Masilotti on 11/28/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

protocol PackageManager {
    static func fetchPackageResults(requestInfo: USPSRequestInfo, completionHandler: (([String]) -> Void)?)
}
