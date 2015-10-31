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
    
    func testTrackPackageButtonShouldBeConnected() {
        XCTAssertNotNil(sut.trackPackageButton)
    }
    
    func testTrackPackageButtonLabel() {
        XCTAssertEqual(sut.trackPackageButton.titleLabel?.text, "Track Package")
    }
    
    func testTrackPackageTextFieldShouldBeConnected() {
        XCTAssertNotNil(sut.trackPackageTextField)
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
    
    
    // MARK: test buttons contain actions
    func testTrackPackageButtonAction() {
        let button = sut.trackPackageButton
        let actions = button.actionsForTarget(sut, forControlEvent: .TouchUpInside) ?? []
        XCTAssertTrue(actions.contains("trackPackage:"))
    }
}
