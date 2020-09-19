//
//  ModelController.swift
//  Car Catalog
//
//  Created by xdrond.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import UIKit
import CoreData


/// ModelController can be rewritten with less dependence on the CarMO class.
struct ModelController {

    /// Container is set up in the AppDelegates so we need to refer that container.
    /// Fatal error if the AppDelegate is unavailable.
    private static var persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No access to the container from \(#file), line: \(#line).")
        }
        return appDelegate.persistentContainer
    }()

    /**
     The method receives CarMO:NSManagedObject properties and loads it to the storage via newBackgroundContext(). Printing error in case saving fails.
     - parameter carObject:CarMO NSManagedObject for saving.
     - throws: Returns an error if the object cannot be created. The method prints error position.
     */
    func createCar(brand: String, model: String, bodyStyle: String?, manufactureYear: String?) throws {

        ModelController.persistentContainer.newBackgroundContext()

        // Create a context from persistentContainer.
        let managedContext = ModelController.persistentContainer.viewContext

        let newCar = CarMO(context: managedContext)
        newCar.brand = brand
        newCar.model = model
        newCar.bodyStyle = bodyStyle
        newCar.manufactureYear = manufactureYear
        managedContext.insert(newCar)

        do {
            try managedContext.save()

        } catch let error as NSError {
            print("Error creating new data. \(error), \(error.userInfo)")
        }
    }

    /**
     The method creates Car:NSManagedObject objects and fills them with random data. Based on the createCar(brand: String, model: String, bodyStyle: String?, manufactureYear: String?) method.
     - parameter numberOfObjects:UInt Number of generated objects or nothing(default 3).
     - throws: Returns an error if the objects cannot be created. The method prints error position.
     */
    func createDefaultData(numberOfObjects: UInt = 3) throws {
        for _ in 1...numberOfObjects {
            do {
                try createCar(brand: carBrands.randomElement()!, model: carModels.randomElement()!, bodyStyle: carBodyStyles.randomElement()!, manufactureYear: carManufactureYears.randomElement()!)
            } catch let error as NSError {
                print("Error loading preloaded data. \(error), \(error.userInfo)")
            }

        }
    }

    /**
     The method asks for actual data and returns the list of objects. Printing error in case fetching fails.
     - returns:[CarMo]? Array of all objects from the storage or nil.
     - throws: Returns an error if the objects cannot be found or retrieved. The method prints error position.
     */
    func retrieveAllCars() throws -> [CarMO]? {

        // Create a context from persistentContainer.
        let managedContext = ModelController.persistentContainer.viewContext

        //Prepare the request of type NSFetchRequest for the entity.
        let fetchRequest = CarMO.carFetchRequest()

        do {
            let result = try managedContext.fetch(fetchRequest)
            return result

        } catch let error as NSError {
            print("Data could not be found. \(error), \(error.userInfo)")
        }
        return nil
    }


    /**
     The method receives edited CarMO:NSManagedObject, checks for availability it from the storage via viewContext() and update it.
     - parameter carObject:CarMO NSManagedObject with edited properties.
     - throws: Returns an error if the object cannot be found or updated. The method prints error position.
     */
    func updateData(carToUpdate: CarMO) throws {

        // Create a context from persistentContainer.
        let managedContext = ModelController.persistentContainer.viewContext

        //        Prepare the request of type NSFetchRequest for the entity.
        //        let fetchRequest = CarMO.carFetchRequest()

        //        fetchRequest.predicate = NSPredicate(format: "brand == %@ AND model == %@ AND bodyStyle == %@ AND manufactureYear == %@", brand, model, bodyStyle ?? "", manufactureYear ?? "")

        do {
            try carToUpdate.validateForUpdate()
            managedContext.insert(carToUpdate)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Context saving error. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("The data cannot be updated. \(error), \(error.userInfo)")
        }
    }

    /**
     The method receives CarMO:NSManagedObject, checks for availability it from the storage via viewContext() and removes it.
     - parameter carObject:CarMO NSManagedObject for removes.
     - throws: Returns an error if the object cannot be found or deleted. The method prints error position.
     */
    func deleteData(carToDelete: CarMO) throws {

        let managedContext = ModelController.persistentContainer.viewContext

        do {
            try carToDelete.validateForDelete()
            managedContext.delete(carToDelete)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Context saving error. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("The data cannot be deleted. \(error), \(error.userInfo)")
        }
    }

}

// Preloaded data.
fileprivate let carBrands: Set = ["Tesla", "Toyota", "Nissan", "Hyundai", "Honda", "Mini"]
fileprivate let carModels: Set = ["Model S", "Prius", "Leaf", "Kona EV", "e", "Electric"]
fileprivate let carBodyStyles: Set = ["sedan", "coupe", "hatchback", "minivan", "truck", "roadster"]
fileprivate let carManufactureYears: Set = ["1998", "2014", "2016", "2005", "2008", "2020"]
