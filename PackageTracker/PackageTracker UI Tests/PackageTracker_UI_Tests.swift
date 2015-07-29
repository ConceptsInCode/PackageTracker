//
//  PackageTracker_UI_Tests.swift
//  PackageTracker UI Tests
//
//  Created by BJ on 6/19/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import Foundation
import XCTest

@testable import PackageTracker

class PackageTracker_UI_Tests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTrackingPackageWithIDRetrievesList() {
        
        let filePath = NSBundle(forClass: self.dynamicType).pathForResource("USPSConfig", ofType: "json")!
        let data = NSData(contentsOfFile: filePath)!
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String : String]
        guard let packageID = json?["packageID"] else {
            XCTFail("no package ID found")
            return
        }

        let app = XCUIApplication()
        let packageIdInputFieldTextField = app.textFields["Package ID input field"]
        packageIdInputFieldTextField.tap()
        packageIdInputFieldTextField.typeText(packageID)
        app.buttons["Track Package"].tap()

        let cell = app.tables.cells.elementAtIndex(0)
        cell.swipeUp()
        XCTAssertEqual(cell.exists, true)
        
        cell.tap()
        
        let table = app.tables
        let count = table.cells.count

        XCTAssertTrue(count > 0)
        
    }
    
}
