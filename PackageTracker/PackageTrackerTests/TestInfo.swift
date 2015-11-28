//
//  TestInfo.swift
//  PackageTracker
//
//  Created by Hank Turowski on 5/10/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import UIKit
import XCTest

@testable
import PackageTracker

class TestInfo: XCTestCase {
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
}
