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
    var requestURL: String {
        return "http://production.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=" + serializedXML
    }
    
    var serializedXML: String {
        return "<?xml version=\"1.0\" encoding=\"UTF‐8\" ?><TrackFieldRequest USERID=\"\(userID)\"><TrackID ID=\"\(packageID)\"></TrackID></TrackFieldRequest>"
    }
    
}
