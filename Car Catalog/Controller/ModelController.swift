//
//  ModelController.swift
//  Car Catalog
//
//  Created by xdrond on 16.09.2020.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import UIKit
import CoreData

class ModelController {

    // Persistent container from AppDelegate.
    static var persistentContainer: NSPersistentContainer! = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer
    }()


    func createDefaultData() {
        guard let persistentContainer = ModelController.persistentContainer else { fatalError("Не удаётся получить доступ к контейнеру из метода createDefaultData()") }

        persistentContainer.newBackgroundContext()

        //We need to create a context from this container
        let managedContext = persistentContainer.viewContext

        //Now let’s create an entity and new user records.
        let carEntity = NSEntityDescription.entity(forEntityName: "Car", in: managedContext)!

        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop

        for _ in 1...6 {
            let car = NSManagedObject(entity: carEntity, insertInto: managedContext)
            car.setValue(carBrands.randomElement(), forKeyPath: "brand")
            car.setValue(carModels.randomElement(), forKey: "model")
            car.setValue(carBodyStyles.randomElement(), forKey: "bodyStyle")
            car.setValue(carManufactureYears.randomElement(), forKey: "manufactureYear")
        }

        //Now we have set all the values. The next step is to save them inside the Core Data

        do {
            print("managedContext: \(managedContext.insertedObjects)")
            try managedContext.save()

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func retrieveData() {

        guard let persistentContainer = ModelController.persistentContainer else { fatalError("Не удаётся получить доступ к контейнеру из метода createDefaultData()") }

        //We need to create a context from this container
        let managedContext = persistentContainer.viewContext

        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "brand") as! String)
            }

        } catch {

            print("Failed")
        }
    }

    func deleteData(){

        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur3")

        do
        {
            let test = try managedContext.fetch(fetchRequest)

            let objectToDelete = test[0] as! NSManagedObject
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
