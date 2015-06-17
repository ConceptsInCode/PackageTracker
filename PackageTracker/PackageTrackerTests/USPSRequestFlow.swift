//
//  XMLRequestCreationTests.swift
//  PackageTracker
//
//  Created by BJ on 5/25/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import UIKit
import XCTest

class USPSRequestFlow: XCTestCase {
    
    func testProvidingRequestInfoReturnsSerializedXML() {
        // given
        
        let userID = "conceptsincode"
        let packageID = "12345"
        
        let uspsRequestInfo = USPSRequestInfo(userID: userID, packageID: packageID)
    
        let expectedXMLString = "ShippingAPI.dll?API=TrackV2&XML=%3C?xml%20version=%221.0%22%20encoding=%22UTF%E2%80%908%22%20?%3E%3CTrackFieldRequest%20USERID=%22conceptsincode%22%3E%3CTrackID%20ID=%2212345%22%3E%3C/TrackID%3E%3C/TrackFieldRequest%3E"
        
        // when
        let resultXMLString = uspsRequestInfo.serializedXML

        // then
        XCTAssertEqual(resultXMLString, expectedXMLString, "XML strings should be equal")
    }
    
    func testInfoCreation() {
        let xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><TrackResponse><TrackInfo ID=\"9400116901500000000000\"><TrackSummary><EventTime>1:18 pm</EventTime><EventDate>April 22, 2015</EventDate><Event>Delivered, In/At Mailbox</Event><EventCity>AVON LAKE</EventCity><EventState>OH</EventState><EventZIPCode>44012</EventZIPCode><EventCountry/><FirmName/><Name/><AuthorizedAgent>false</AuthorizedAgent><DeliveryAttributeCode>01</DeliveryAttributeCode></TrackSummary><TrackDetail><EventTime>5:25 am</EventTime><EventDate>April 22, 2015</EventDate><Event>Arrived at Post Office</Event><EventCity>AVON LAKE</EventCity><EventState>OH</EventState><EventZIPCode>44012</EventZIPCode><EventCountry/><FirmName/><Name/><AuthorizedAgent>false</AuthorizedAgent></TrackDetail><TrackDetail><EventTime>10:45 pm</EventTime><EventDate>April 21, 2015</EventDate><Event>Arrived at USPS Facility</Event><EventCity>CLEVELAND</EventCity><EventState>OH</EventState><EventZIPCode>44101</EventZIPCode><EventCountry/><FirmName/><Name/><AuthorizedAgent>false</AuthorizedAgent></TrackDetail></TrackInfo></TrackResponse>"
        
        let data = (xmlString as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        let xmlParser = NSXMLParser(data: data)
        let packageInfo = Info()
        xmlParser.delegate = packageInfo
        xmlParser.parse()
        
        XCTAssertEqual(packageInfo.id, "9400116901500000000000")
        XCTAssertEqual(packageInfo.summary.event, "Delivered, In/At Mailbox")
        XCTAssertEqual(packageInfo.details[0].event , "Arrived at Post Office")
        XCTAssertEqual(packageInfo.details[1].event , "Arrived at USPS Facility")
    }
    
    func testFullUSPSURLCreation() {
        let userID = "conceptsincode"
        let packageID = "12345"
        
        let expectedURLString = "http://production.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=%3C?xml%20version=%221.0%22%20encoding=%22UTF%E2%80%908%22%20?%3E%3CTrackFieldRequest%20USERID=%22conceptsincode%22%3E%3CTrackID%20ID=%2212345%22%3E%3C/TrackID%3E%3C/TrackFieldRequest%3E"
        
        let request = USPSRequestInfo(userID: userID, packageID: packageID)
        guard let url = request.requestURL else {
            XCTFail("url should not be nil")
            return
        }
        
        XCTAssertEqual(url.absoluteString ?? "", expectedURLString)
    }
    
    func testDataGetsReceived() {
        let filePath = NSBundle.mainBundle().pathForResource("USPSConfig", ofType: "json")!
        let data = NSData(contentsOfFile: filePath)!
        var json: [String : String]!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String : String]
        } catch {
            XCTFail("failed with error \(error)")
        }
        
        guard let userID = json["userID"], packageID = json["packageID"] else {
            XCTFail("userID and packageID should be gotten from json")
            return
        }
        
        let request = USPSRequestInfo(userID: userID, packageID: packageID)
        let expectation = expectationWithDescription("testing getting data")
        
        USPSManager.fetchPackageResults(request) { (items: [String]) -> Void in
            XCTAssertGreaterThan(items.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(8.0) { (error: NSError?) -> Void in
            print("failed with error: \(error?.localizedDescription ?? String())")
        }
    }
    

}
