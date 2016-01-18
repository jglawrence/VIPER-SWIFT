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
    var persistentStoreCoordinator : NSPersistentStoreCoordinator?
    var managedObjectModel : NSManagedObjectModel?
    var managedObjectContext : NSManagedObjectContext?
    
    override init() {
        managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        guard let moc = managedObjectModel else {
            super.init()
            return
        }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: moc)
        
        let domains = NSSearchPathDomainMask.UserDomainMask
        let directory = NSSearchPathDirectory.DocumentDirectory

        let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: domains).last
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        if let storeURL = applicationDocumentsDirectory?.URLByAppendingPathComponent("VIPER-SWIFT.sqlite") {

        let _ = try? persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: "", URL: storeURL, options: options)
        }

        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext!.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext!.undoManager = nil
        
        super.init()
    }
    
    func fetchEntriesWithPredicate(predicate: NSPredicate, sortDescriptors: [AnyObject], completionBlock: (([ManagedTodoItem]) -> Void)!) {
        let fetchRequest = NSFetchRequest(entityName: "TodoItem")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []
        
        managedObjectContext?.performBlock {
            let queryResults = try? self.managedObjectContext?.executeFetchRequest(fetchRequest)
            let managedResults = queryResults! as! [ManagedTodoItem]
            completionBlock(managedResults)
        }
    }
    
    func newTodoItem() -> ManagedTodoItem? {
        guard let moc = managedObjectContext, entityDescription = NSEntityDescription.entityForName("TodoItem", inManagedObjectContext: moc) else { return nil }

        if let newEntry = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: moc) as? ManagedTodoItem {
        
        return newEntry
        } else {
            return nil
        }
    }

    func save() {
        do {
            try managedObjectContext?.save()
        } catch _ {
        }
    }
}