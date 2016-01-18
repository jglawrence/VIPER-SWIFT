//
//  CoreDataStore.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore : NSObject {
    let managedObjectContext : NSManagedObjectContext?

    override init() {
        guard let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil) else {
            managedObjectContext = nil
            super.init()
            return
        }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]

        if let storeURL = applicationDocumentsDirectory?.URLByAppendingPathComponent("VIPER-SWIFT.sqlite") {
            let _ = try? persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: "", URL: storeURL, options: options)
        }

        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext?.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext?.undoManager = nil

        super.init()
    }

    func fetchEntriesWithPredicate(predicate: NSPredicate, sortDescriptors: [AnyObject], completionBlock: [ManagedTodoItem]? -> Void) {
        let fetchRequest = NSFetchRequest(entityName: "TodoItem")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []

        managedObjectContext?.performBlock {
            let queryResults = try? self.managedObjectContext?.executeFetchRequest(fetchRequest)
            let managedResults = queryResults as? [ManagedTodoItem]
            completionBlock(managedResults)
        }
    }

    func newTodoItem() -> ManagedTodoItem? {
        guard let moc = managedObjectContext,
            entityDescription = NSEntityDescription.entityForName("TodoItem", inManagedObjectContext: moc) else { return nil }

        return NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: moc) as? ManagedTodoItem
    }

    func save() {
        let _ = try? managedObjectContext?.save()
    }
}
