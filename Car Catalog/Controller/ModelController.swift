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
     The method receives CarMO:NSManagedObject and loads it to the storage via newBackgroundContext(). Printing error in case saving fails.
     - parameter carObject:CarMO NSManagedObject for saving.
     */
    func createCar(brand: String, model: String, bodyStyle: String?, manufactureYear: String?) {

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
            print("managedContext: \(managedContext.insertedObjects)")
            try managedContext.save()

        } catch let error as NSError {
            print("Data could not be saved. \(error), \(error.userInfo)")
        }
    }

    /**
     The method creates Car:NSManagedObject objects and fills them with random data. Printing error in case saving fails.
     - parameter numberOfObjects:UInt Number of generated objects or nothing(default 6).
     */
    func createDefaultData(numberOfObjects: UInt = 6) {

        ModelController.persistentContainer.newBackgroundContext()

        // Create a context from this container.
        let managedContext = ModelController.persistentContainer.viewContext

        //  Creating Car:NSManagedObject objects and fill them with random data.
        for _ in 1...numberOfObjects {
            let car = CarMO(context: managedContext)
            car.brand = carBrands.randomElement()!
            car.model = carModels.randomElement()!
            car.bodyStyle = carBodyStyles.randomElement()!
            car.manufactureYear = carManufactureYears.randomElement()!
        }

        // Set all the values. The next step is to save them inside the Core Data.

        do {
            print("managedContext: \(managedContext.insertedObjects)")
            try managedContext.save()

        } catch let error as NSError {
            print("Data could not be saved. \(error), \(error.userInfo)")
        }
    }

    /**
     The method asks for actual data and returns the list of objects. Printing error in case fetching fails.
     - returns:[Car]? Array of objects from the storage or nil.
     */
    func retrieveData() -> [CarMO]? {

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
     The method searches for the specified car in the storage and updates the specified data.
     - bug: Fatal error if the described car is not in the storage.
     */
    func updateData(brand: String, model: String, bodyStyle: String?, manufactureYear: String?) {

        // Create a context from persistentContainer.
        let managedContext = ModelController.persistentContainer.viewContext

        //Prepare the request of type NSFetchRequest for the entity.
        let fetchRequest = CarMO.carFetchRequest()

        fetchRequest.predicate = NSPredicate(format: "brand == %@ AND model == %@ AND bodyStyle == %@ AND manufactureYear == %@", brand, model, bodyStyle ?? "", manufactureYear ?? "")
        do
        {
            let test = try managedContext.fetch(fetchRequest)

            // MARK: - Test code, will be removed.

            let updCar = test[0] as! CarMO
            updCar.brand = "New updated " + brand
            updCar.model = "New updated " + model
            updCar.bodyStyle = "New updated " + (bodyStyle ?? "")
            updCar.manufactureYear = "New updated " + (manufactureYear ?? "")
            managedContext.insert(updCar)
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }

    }

    /**
     The method searches in the storage and deletes the specified car.
     - bug: Fatal error if the described car is not in the storage.
     */
    func deleteData(brand: String, model: String, bodyStyle: String?, manufactureYear: String?){

        // Create a context from persistentContainer.
        let managedContext = ModelController.persistentContainer.viewContext

        let fetchRequest = CarMO.carFetchRequest()

        fetchRequest.predicate = NSPredicate(format: "brand == %@ AND model == %@ AND bodyStyle == %@ AND manufactureYear == %@", brand, model, bodyStyle ?? "", manufactureYear ?? "")

        do
        {
            let test = try managedContext.fetch(fetchRequest)

            let objectToDelete = test[0] as! CarMO
            managedContext.delete(objectToDelete)

            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }

        }
        catch
        {
            print(error)
        }
    }
}

// Preloaded data.
fileprivate let carBrands: Set = ["Tesla", "Toyota", "Nissan", "Hyundai", "Honda", "Mini"]
fileprivate let carModels: Set = ["Model S", "Prius", "Leaf", "Kona EV", "e", "Electric"]
fileprivate let carBodyStyles: Set = ["sedan", "coupe", "hatchback", "minivan", "truck", "roadster"]
fileprivate let carManufactureYears: Set = ["1998", "2014", "2016", "2005", "2008", "2020"]
