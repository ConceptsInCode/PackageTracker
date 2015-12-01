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
    
    var baseURLString: String {
        return "http://production.shippingapis.com"
    }
    
    var requestURL: NSURL? {
        let baseURL = NSURL(string: baseURLString)!
        return NSURL(string: serializedXML, relativeToURL: baseURL)!
    }
    
    var serializedXML: String {
        get {
            let urlText = "ShippingAPI.dll?API=TrackV2&XML=<?xml version=\"1.0\" encoding=\"UTF‐8\" ?><TrackFieldRequest USERID=\"\(userID)\"><TrackID ID=\"\(packageID)\"></TrackID></TrackFieldRequest>"
            let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet()
            return urlText.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? ""
        }
    }
    
}

extension USPSRequestInfo: Equatable { }
func ==(lhs: USPSRequestInfo, rhs: USPSRequestInfo) -> Bool {
    return lhs.userID == rhs.userID && lhs.packageID == rhs.packageID
}
