//
//  CoreDataManager.swift
//  tfe
//
//  Created by martin d'hoedt on 4/5/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    let container : NSPersistentContainer
    let context : NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "StandsContainer")
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
