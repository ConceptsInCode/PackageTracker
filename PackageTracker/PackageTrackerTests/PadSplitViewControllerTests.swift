//
//  PadSplitViewControllerTests.swift
//  PackageTracker
//
//  Created by BJ Miller on 10/20/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import XCTest
@testable import PackageTracker

class PadSplitViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var sut: PadSplitViewController!
    
    override func setUp() {
        super.setUp()

        sut = storyboard.instantiateViewControllerWithIdentifier("PadSplitViewController") as! PadSplitViewController
        UIApplication.sharedApplication().keyWindow!.rootViewController = sut
        XCTAssertNotNil(sut.view)
    }
    
    // MARK: test initial state
    func testNumberOfViewControllersIsInitially2() {
        XCTAssertEqual(sut.viewControllers.count, 2)
    }
    
    func testMasterViewControllerRootIsNavController() {
        let nav = sut.viewControllers.first
        XCTAssertTrue(nav is UINavigationController, "first view controller should be UINavigationController. Is \(sut.viewControllers.first?.classForCoder)")
    }

    func testNavControllerTopVCIsInitiallyTrackingHistoryVC() {
        let navVC = sut.viewControllers.first as? UINavigationController
        let vc = navVC?.topViewController
        XCTAssertNotNil(vc)
        XCTAssertTrue(vc is TrackingHistoryViewController, "Nav top VC should be Tracking History VC. Is \(vc?.classForCoder)")
    }
    
    func testViewControllerIsDetailVCOniPad() {
        let detail = sut.viewControllers.last
        XCTAssertTrue(detail is ViewController)
    }
    
    
    // MARK: test ability to set PersistenceController dependency to MasterVC
    func testSettingPersistenceControllerToMasterViewController() {
        guard let nav = sut.viewControllers.first as? UINavigationController,
            var master = nav.topViewController as? PersistenceControllerAccessible else {
            XCTFail("MasterVC should conform to PersisntenceControllerAccessible protocol.")
            return
        }
        
        // given
        let expectation = expectationWithDescription("waiting for core data to set up")
        
        // when
        _ = PersistenceController(modelName: "PackageModel", storeType: .InMemory) { pvc in
            expectation.fulfill()
            self.sut.setPersistenceControllerForMasterViewController(pvc)
            XCTAssertNotNil(master.persistenceController)
        }
        
        // then
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testAskingSplitViewToFetchAsksMasterToFetchAndClearsItemsArray() {
        // given
        guard let detail = sut.viewControllers.last as? ViewController else {
            XCTFail("should have ref to detail vc")
            return
        }
        detail.items = ["1", "2", "3"]

        // when
        sut.fetchPackageInfo(packageID: "")
        
        // then
        XCTAssertEqual(detail.items, [])
    }
    
}
