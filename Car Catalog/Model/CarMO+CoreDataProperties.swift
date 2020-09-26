//
//  Car+CoreDataProperties.swift
//  Car Catalog
//
//  Created by xdrond.
//  Copyright © 2020 romanromanov. All rights reserved.
//
//

import Foundation
import CoreData


extension CarMO {

    @nonobjc public class func carFetchRequest() -> NSFetchRequest<CarMO> {
        return NSFetchRequest<CarMO>(entityName: "CarMO")
    }

    @NSManaged public var brand: String 
    @NSManaged public var model: String
    @NSManaged public var lastChange: Date
    @NSManaged public var manufactureYear: String?
    @NSManaged public var bodyStyle: String?

}

