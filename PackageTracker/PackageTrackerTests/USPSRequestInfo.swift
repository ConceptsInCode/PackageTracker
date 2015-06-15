//
//  USPSRequestInfo.swift
//  PackageTracker
//
//  Created by BJ on 5/25/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import Foundation

struct USPSRequestInfo {
    let userID: String
    let packageID: String
    var requestURL: NSURL? {
//        return NSURL(string: serializedXML, relativeToURL: NSURL(string: baseURLString)!)
        return NSURL(string: serializedXML)
    }
    
    var baseURLString: String {
        return "http://production.shippingapis.com"
    }
    
    var serializedXML: String {
        get {
            let urlText = "http://production.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=<?xml version=\"1.0\" encoding=\"UTF‐8\" ?><TrackRequest USERID=\"\(userID)\"><TrackID ID=\"\(packageID)\"></TrackID></TrackRequest>"
            return urlText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) ?? ""
        }
    }
    
}
