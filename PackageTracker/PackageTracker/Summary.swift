//
//  Summary.swift
//  PackageTracker
//
//  Created by Hank Turowski on 5/10/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import Foundation

class Summary: NSObject, NSXMLParserDelegate {
    var eventTime = ""
    var eventDate = ""
    var event = ""
    var eventCity = ""
    var eventState = ""
    var eventZipCode = ""
    var eventCountry = ""
    var firmName = ""
    var name = ""
    var authorizedAgent = ""
    var deliveryAttributeCode = ""
    

    private var parsingContext : String? = nil
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI : String?, qualifiedName: String?, attributes attributeDict: [NSObject: AnyObject]) {
        parsingContext = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI : String?, qualifiedName: String?) {
        parsingContext = nil
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if let context = parsingContext, foundString = string {
            switch context {
            case "EventTime": eventTime = foundString
            case "EventDate": eventDate = foundString
            case "Event": event = foundString
            case "EventCity": eventCity = foundString
            case "EventState": eventState = foundString
            case "EventZipCode": eventZipCode = foundString
            case "EventCountry": eventCountry = foundString
            case "FirmName": firmName = foundString
            case "Name": name = foundString
            case "AuthorizedAgent": authorizedAgent = foundString
            case "DeliveryAttributeCode" : deliveryAttributeCode = foundString
            default: break
            }
        }
    }
}
