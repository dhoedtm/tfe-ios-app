//
//  CoreDataManager.swift
//  tfe
//
//  Created by martin d'hoedt on 4/5/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let containerName = "StandsContainer"
    static let shared = CoreDataManager()
    var container : NSPersistentContainer
    var context : NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: CoreDataManager.containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("[CoreDataManager] ERROR loading core data : \(error)")
            } else {
                print("[CoreDataManager] loaded core data")
            }
        }
        context = container.viewContext
    }
    
    /// Deletes all entity stores from the persistent core data storage
    /// (thanks to : https://www.advancedswift.com/batch-delete-everything-core-data-swift/)
    func resetContainer() {
        print("[CoreDataManager][resetContainer]")
        let storeContainer = container.persistentStoreCoordinator
        
        // delete each existing persistent store
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch(let error) {
                print("[CoreDataManager][resetContainer] ERROR destroyPersistentStore :\n\(error)")
            }
        }
        
        // re-init container
        container = NSPersistentContainer(name: CoreDataManager.containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("[CoreDataManager] ERROR loading core data : \(error)")
            } else {
                print("[CoreDataManager] loaded core data")
            }
        }
        context = container.viewContext
    }
    
    /// Saves local data stored in the context into the persistant CoreData container
    func save() {
        do {
            try context.save()
        } catch (let error) {
            print("[CoreDataManager][save] error : \(error)")
        }
    }
}
