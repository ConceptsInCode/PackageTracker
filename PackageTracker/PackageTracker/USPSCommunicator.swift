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
        guard let url = requestInfo.requestURL else {
            return
        }
        
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
                print("not HTTP response. \(error)")
            }
        }
        
        task!.resume()
    }
}

