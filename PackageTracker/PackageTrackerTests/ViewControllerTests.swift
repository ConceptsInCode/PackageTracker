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
        _ = sut.view
    }
    

    func testTrackPackageButtonOutletIsConnected() {
        XCTAssertNotNil(sut.trackPackageButton)
    }
    
    func testTrackPackageButtonLabel() {
        XCTAssertEqual(sut.trackPackageButton.titleLabel?.text, "Track Package")
    }
    
    func testShowHistoryButtonOutletIsConnected() {
        XCTAssertNotNil(sut.showHistoryButton)
    }
    
    func testTrackingTextFieldOutletIsConnected() {
        XCTAssertNotNil(sut.trackingTextField)
    }
    
    func testTableViewOutletIsConnected() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testHistoryButtonAction() {
        let button = sut.showHistoryButton
        let actions = button.actionsForTarget(sut, forControlEvent: .TouchUpInside) ?? []
        XCTAssertTrue(actions.contains("showHistory:"))
    }
    
    func testHistoryButtonIsDisabledUponInitialLoad() {
        XCTAssertFalse(sut.showHistoryButton.enabled)
    }
    
    func testHistoryButtonImagesForStates() {
        XCTAssertTrue(sut.showHistoryButton.imageForState(.Disabled) == UIImage(named: "disabledClock"))
        XCTAssertTrue(sut.showHistoryButton.imageForState(.Normal) == UIImage(named: "clock"))
    }
    
    
    // text actions produce results
    func testShowHistoryButtonPerformsSegue() {
        // when
        sut.showHistory(nil)
        
        // then
        if let _ = sut.presentedViewController as? TrackingHistoryViewController {
            XCTAssert(true, "presentedViewController should be TrackingHistoryViewController")
        } else {
            XCTFail("presentedViewController should be TrackingHistoryViewController. \(sut.presentedViewController?.description)")
        }
    }
    
}
