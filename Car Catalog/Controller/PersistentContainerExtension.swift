//
//  PersistentContainerExtension.swift
//  Car Catalog
//
//  Created by xdrond on 24.09.2020.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
