//
//  Detail.swift
//  PackageTracker
//
//  Created by Hank Turowski on 5/10/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import Foundation

class Detail: NSObject, NSXMLParserDelegate {
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

    private var parsingContext : String? = nil
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI : String?, qualifiedName: String?, attributes attributeDict: [String: String]) {
        parsingContext = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI : String?, qualifiedName: String?) {
        parsingContext = nil
    }
    
    func parser(parser: NSXMLParser, foundCharacters: String) {
        if let context = parsingContext {
            switch context {
            case "EventTime": eventTime = foundCharacters
            case "EventDate": eventDate = foundCharacters
            case "Event": event = foundCharacters
            case "EventCity": eventCity = foundCharacters
            case "EventState": eventState = foundCharacters
            case "EventZipCode": eventZipCode = foundCharacters
            case "EventCountry": eventCountry = foundCharacters
            case "FirmName": firmName = foundCharacters
            case "Name": name = foundCharacters
            case "AuthorizedAgent": authorizedAgent = foundCharacters
            default: break
            }
        }
    }
    
    override var description: String {
        return "\(eventDate), \(eventTime), \(event)"
    }
}


