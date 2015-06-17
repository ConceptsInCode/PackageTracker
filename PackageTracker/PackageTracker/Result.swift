//
//  Result.swift
//  PackageTracker
//
//  Created by BJ on 6/5/15.
//  Copyright (c) 2015 Concepts In Code. All rights reserved.
//

import Foundation

enum Result<T> {
    case Value(T)
    case Error(ErrorType)
}