//
//  USPSCommunicator.swift
//  PackageTracker
//
//  Created by BJ on 6/14/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//

import Foundation

struct USPSCommunicator {
    
    static func fetchPackageResults(requestInfo: USPSRequestInfo, completionHandler: ((data: NSData) -> Void)?) -> () {
        let url = requestInfo.requestURL
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { data, response, error in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    print("i'm ok")
                    guard let data = data else {
                        break
                    }
                    completionHandler?(data: data)
                default:
                    print("i'm not okaaaaaay")
                }
            } else {
                print("not HTTP response")
            }
        }
        
        task?.resume()
    }
}

struct USPSManager {
    
    static func fetchPackageResults(requestInfo: USPSRequestInfo, completionHandler: ([String] -> Void)?) {
        
        USPSCommunicator.fetchPackageResults(requestInfo) { (data) -> Void in
            let xmlParser = NSXMLParser(data: data)
            let packageInfo = Info()
            xmlParser.delegate = packageInfo
            xmlParser.parse()
            let strings = packageInfo.details.map { $0.description }
            completionHandler?(strings)
        }
    }
}