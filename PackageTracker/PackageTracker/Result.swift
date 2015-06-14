//
//  Result.swift
//  PackageTracker
//
//  Created by BJ on 6/5/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import Foundation

class Box<T> {
    var value: T
    init(_ value: T) { self.value = value }
}

enum Result<T> {
    case Value(Box<T>)
    case Error(NSError)
}