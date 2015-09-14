//
//  TrackingHistoryViewControllerTests.swift
//  PackageTracker
//
//  Created by BJ Miller on 9/13/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import XCTest
@testable import PackageTracker

class TrackingHistoryViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var sut: TrackingHistoryViewController!
    
    override func setUp() {
        super.setUp()

        sut = storyboard.instantiateViewControllerWithIdentifier("TrackingHistoryViewController") as! TrackingHistoryViewController
        _ = sut.view
    }
    
    
    func testTableViewOutletIsConnected() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testTableViewDelegateAndDataSourceAreConnected() {
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.delegate)
    }
    
    
    func testItemsPropertyIsEmptyStringArrayAtFirst() {
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func testPersistenceControllerVariableIsNil() {
        XCTAssertNil(sut.persistenceController)
    }
}
