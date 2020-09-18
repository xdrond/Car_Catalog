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

        // MARK: - Test code, will be removed.
        for auto in modelController.retrieveData()! {
            print("\(auto.brand) - \(auto.model)")
        }
        // Do any additional setup after loading the view.
    }


}

