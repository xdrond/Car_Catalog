//
//  Car.swift
//  Car Catalog
//
//  Created by xdrond on 18.09.2020.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import Foundation

class Car {

    var brand: String
    var model: String
    var manufactureYear: String?
    var bodyStyle: String?

    init(car: CarMO) {
        self.brand = car.brand
        self.model = car.model
        self.manufactureYear = car.manufactureYear
        self.bodyStyle = car.bodyStyle
    }

    init(brand: String, model: String, bodyStyle: String?, manufactureYear: String?) {
        self.brand = brand
        self.model = model
        self.manufactureYear = manufactureYear
        self.bodyStyle = bodyStyle
    }
}
