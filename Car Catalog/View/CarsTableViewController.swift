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
        do {
            try cars = modelController.retrieveAllCars()
        } catch let error as NSError {
            presentAlert(errorMessage: error.localizedDescription)
        }

        self.tableView.register(CarTableViewCell.self, forCellReuseIdentifier: "CarTableViewCell")
        self.tableView.dataSource = self

    }

    func presentAlert(errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: nil)
    }


}

extension CarsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            guard let count = self.cars?.count else { return 0 }
            return count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: indexPath) as! CarTableViewCell

        guard let brand = self.cars?[indexPath.row].brand else { return cell }
        guard let model = self.cars?[indexPath.row].model else { return cell }

        cell.textLabel?.text = brand + " " + model

        return cell
    }
}

