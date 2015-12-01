//
//  ViewControllerTests.swift
//  PackageTracker
//
//  Created by BJ Miller on 9/12/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import XCTest
@testable import PackageTracker

class ViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var sut: ViewController!
    let packageManager = MockPackageManager()
    
    override func setUp() {
        super.setUp()

        sut = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        sut.packageManager = packageManager
        UIApplication.sharedApplication().keyWindow!.rootViewController = sut
        XCTAssertNotNil(sut.view)
    }

    func testTableViewOutletIsConnected() {
        XCTAssertNotNil(sut.tableView)
    }

    func test_OnLoad_FetchesPackageDetails() {
        sut.fetchPackageInfo(packageID: "package")

        let requestInfo = USPSRequestInfo(userID: "908SIXFI7346", packageID: "package")
        XCTAssertEqual(packageManager.lastRequestInfo, requestInfo)
    }

    func test_SuccessfulFetch_DisplaysTheResults() {
        packageManager.nextInfos = ["Departed", "Transferred", "Arrived"]

        sut.fetchPackageInfo(packageID: "package")

        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 0), 3)
        let firstIndex = NSIndexPath(forRow: 0, inSection: 0)
        let firstCell = sut.tableView(sut.tableView, cellForRowAtIndexPath: firstIndex)
        XCTAssertEqual(firstCell.textLabel?.text, "Departed")
    }
}
