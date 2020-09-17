//
//  ViewController.swift
//  Car Catalog
//
//  Created by xdrond on 16.09.2020.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var modelController: ModelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = ModelController()
        guard (modelController != nil) else {
            fatalError("VC не получил контроллер модели!")
        }
        
        modelController.retrieveData()
        // Do any additional setup after loading the view.
    }


}

