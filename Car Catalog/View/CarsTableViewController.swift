//
//  ViewController.swift
//  Car Catalog
//
//  Created by xdrond.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {

    var modelController: ModelController!

    var cars: [CarMO]?

    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = ModelController()


        // Do any additional setup after loading the view.
    }

}

