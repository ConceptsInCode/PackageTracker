//
//  MockPackageManager.swift
//  PackageTracker
//
//  Created by Joe Masilotti on 11/28/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

@testable import PackageTracker

class MockPackageManager: PackageManager {
    var lastRequestInfo: USPSRequestInfo?

    func fetchPackageResults(requestInfo: USPSRequestInfo, completionHandler: PackageCompletion?) {
        lastRequestInfo = requestInfo
    }
}
