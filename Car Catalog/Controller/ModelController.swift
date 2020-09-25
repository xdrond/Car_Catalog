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
class ModelController {

    /// Container is set up in the AppDelegates so we need to refer context from that.
    /// Fatal error if the AppDelegate is unavailable.
    private static var context: NSManagedObjectContext! = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No access to the container from \(#file), line: \(#line).")
        }
        return appDelegate.persistentContainer.viewContext
    }()

    /**
     The method receives CarMO:NSManagedObject properties and loads it to the storage via context. Printing error in case saving fails.
     - parameter carObject:CarMO NSManagedObject for saving.
     */
    func createCar(brand: String, model: String, bodyStyle: String?, manufactureYear: String?) {

        guard let context = ModelController.context else { return }

        let newCar = CarMO(context: context)
        newCar.brand = brand
        newCar.model = model
        newCar.bodyStyle = bodyStyle
        newCar.manufactureYear = manufactureYear
        context.insert(newCar)

        do {
            try context.save()

        } catch let error as NSError {
            print("Error creating new data. \(error), \(error.userInfo)")
        }
    }

    /**
     The method creates Car:NSManagedObject objects and fills them with random data. Based on the createCar(brand: String, model: String, bodyStyle: String?, manufactureYear: String?) method.
     - parameter numberOfObjects:UInt Number of generated objects or nothing(default 3).
     */
    func createDefaultData(numberOfObjects: UInt = 3) {
        for _ in 1...numberOfObjects {
            createCar(brand: carBrands.randomElement()!,
                      model: carModels.randomElement()!,
                      bodyStyle: carBodyStyles.randomElement()!,
                      manufactureYear: carManufactureYears.randomElement()!)
        }
    }

    /**
     The method asks for actual data and returns the list of objects. Printing error in case fetching fails.
     - returns:[CarMo]? Array of all objects from the storage or nil.
     */
    func retrieveAllCars() -> [CarMO]? {

        guard let context = ModelController.context else { return nil }

        //Prepare the request of type NSFetchRequest for the entity.
        let fetchRequest = CarMO.carFetchRequest()

        do {
            let result = try context.fetch(fetchRequest)
            return result

        } catch let error as NSError {
            print("Data could not be found. \(error), \(error.userInfo)")
        }
        return nil
    }

    
    /**
     The method receives CarMO:NSManagedObject, checks for availability it from the storage via viewContext() and removes it.
     - parameter carObject:CarMO NSManagedObject for removes.
     */
    func deleteData(carToDelete: CarMO) {

        guard let context = ModelController.context else { return }

        do {
            try carToDelete.validateForDelete()
            context.delete(carToDelete)
            do {
                try context.save()
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
