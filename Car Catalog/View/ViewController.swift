//
//  ViewController.swift
//  Car Catalog
//
//  Created by xdrond.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var modelController: ModelController!

    var cars: [CarMO]?

    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = ModelController()
        cars = try? modelController.retrieveAllCars()!

        // Do any additional setup after loading the view.
    }


}

