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
    
    override func setUp() {
        super.setUp()

        sut = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        UIApplication.sharedApplication().keyWindow!.rootViewController = sut
        XCTAssertNotNil(sut.view)
    }

    func testTableViewOutletIsConnected() {
        XCTAssertNotNil(sut.tableView)
    }
}
