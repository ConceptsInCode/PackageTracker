//
//  USPSManager.swift
//  PackageTracker
//
//  Created by BJ on 6/16/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import Foundation

struct USPSManager: PackageManager {
    
    func fetchPackageResults(requestInfo: USPSRequestInfo, completionHandler: (([String]) -> Void)?) {
        
        USPSCommunicator.fetchPackageResults(requestInfo) { (data) -> Void in
            let xmlParser = NSXMLParser(data: data)
            let packageInfo = Info()
            xmlParser.delegate = packageInfo
            xmlParser.parse()
            let strings = packageInfo.details.map { $0.description }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(strings)
            }
        }
    }
}