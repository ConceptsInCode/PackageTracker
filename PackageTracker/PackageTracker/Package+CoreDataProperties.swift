//
//  Package+CoreDataProperties.swift
//  PackageTracker
//
//  Created by BJ Miller on 7/28/15.
//  Copyright © 2015 Concepts In Code. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Package {

    @NSManaged var packageID: String?
    @NSManaged var packageNickname: String?

}
