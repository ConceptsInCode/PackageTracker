//
//  Info.swift
//  PackageTracker
//
//  Created by Hank Turowski on 5/10/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import Foundation

class Info:  NSObject, NSXMLParserDelegate {

    var id = ""
    var summary = Summary()
    var details = [Detail]()

    private var parsingContext: NSXMLParserDelegate?

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if let currentContext = parsingContext {
            currentContext.parser!(parser, foundCharacters: string)
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI : String?, qualifiedName: String?, attributes attributeDict: [String: String]) {
        if elementName == "TrackInfo" {
            id = attributeDict["ID"] ?? ""
        } else if elementName == "TrackSummary" {
            parsingContext = summary
        } else if elementName == "TrackDetail" {
            details.append(Detail())
            parsingContext = details.last!
        }
        else if let currentContext = parsingContext {
            currentContext.parser!(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qualifiedName, attributes: attributeDict)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI : String?, qualifiedName: String?) {
        if elementName == "TrackSummary" || elementName == "TrackDetail" {
            parsingContext = nil
        } else if let currentContext = parsingContext {
            currentContext.parser!(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qualifiedName)
        }
    }
}