//
//  PersistenceController.swift
//  NewCoreDataStack
//
//  Created by BJ on 6/4/15.
//  Copyright (c) 2015 Six Five Software, LLC. All rights reserved.
//

import Foundation
import CoreData


public enum CoreDataStoreType {
    case SQLite, InMemory, Binary
    
    public var storeTypeString: String {
        switch self {
        case .SQLite:
            return NSSQLiteStoreType
        case .InMemory:
            return NSInMemoryStoreType
        case .Binary:
            return NSBinaryStoreType
        }
    }
}

public struct PersistenceController {

    public let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    private let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    private let callback: (Void -> Void)?
    
    public init(modelName: String, storeType: CoreDataStoreType = .SQLite, callback: (Void -> Void)? = nil) {
        self.callback = callback
        
        let modelURL = NSBundle.mainBundle().URLForResource(modelName, withExtension: "momd")!
        let mom = NSManagedObjectModel(contentsOfURL: modelURL)!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        privateContext.persistentStoreCoordinator = coordinator
        mainContext.parentContext = privateContext
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let psc = self.privateContext.persistentStoreCoordinator!
            let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true, NSSQLitePragmasOption : ["journal_mode" : "DELETE"]] as [NSObject : AnyObject]
            
            let fileManager = NSFileManager.defaultManager()
            let documentsURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
            let storeURL = documentsURL.URLByAppendingPathComponent("\(modelName).sqlite")
    
            try! psc.addPersistentStoreWithType(storeType.storeTypeString, configuration: nil, URL: storeURL, options: options)
            
            dispatch_async(dispatch_get_main_queue()) {
                callback?()
            }
        }
    }
    
    public func save() {
        
        if !privateContext.hasChanges && !mainContext.hasChanges {
            return
        }
        
        mainContext.performBlockAndWait {
            if let _ = try? self.mainContext.save() {
                self.privateContext.performBlock {
                    if let _ =  try? self.privateContext.save() {
                        // success
                    }
                }
            }
        }
        
    }
    
    public func fetchAll(entity entity: String) -> [AnyObject] {
        let fetchRequest = NSFetchRequest(entityName: entity)
        var result = [AnyObject]()
        do {
            result = try mainContext.executeFetchRequest(fetchRequest)
        } catch {
            print("error fetching")
        }
        return result
    }
}

public struct WorkerContext {
    let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    var parentContext: NSManagedObjectContext? {
        return context.parentContext
    }
    
    public init(parent: NSManagedObjectContext) {
        context.parentContext = parent
    }
    
    public func insert(entityName: String) -> NSManagedObject {
        let entity = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context)
        return entity
    }
    
    public func delete(object object: NSManagedObject) {
        context.deleteObject(object)
    }
    
    public func save(completion: (Void -> Void)? = nil) {
        if !context.hasChanges {
            return
        }
        
        context.performBlock {
//            var error: NSError?
//            let didSave = self.context.save(&error)
            try! self.context.save()
            
//            if !didSave {
//                print("error saving worker context. code: \(error?.code ?? 0). error: \(error?.localizedDescription ?? String())")
//            }
            completion?()
        }
    }
}