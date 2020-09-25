//
//  ViewController.swift
//  Car Catalog
//
//  Created by xdrond.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController, PresentUserAlert {

    // Constants.
    let addSegueID = "addCar"
    let editSegueID = "carDetails"
    let cellID = "CarTableViewCell"

    var modelController: ModelController!

    fileprivate var cars = [CarMO]()

    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = ModelController()
        cars = modelController.retrieveAllCars()!
        cars.reverse()

        self.tableView.dataSource = self

    }


    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        switch segue.identifier {
        case editSegueID:
            if let detailsVC = segue.destination as? DetailsViewController {
                detailsVC.detailsTitle = .edit

                // Здесь объектом sender является ячейка, на которую нажимает юзер
                // Получаем indexPath выбранной ячейки с помощью метода indexPathForCell:
                let index = self.tableView.indexPath(for: (sender as! CarTableViewCell))!.row
                detailsVC.carForEdit = cars[index]
            }
        case addSegueID:
            if let detailsVC = segue.destination as? DetailsViewController {
                detailsVC.detailsTitle = .add
            }
        default:
            print("Unknown segue transition.")
        }

    }
}



extension CarsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CarTableViewCell

        cell.textLabel?.text = self.cars[indexPath.row].brand
        cell.detailTextLabel?.text = self.cars[indexPath.row].model

        return cell
    }

    /// Delete car
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            modelController!.deleteData(carToDelete: cars[indexPath.row])
            cars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

public enum DetailsTitleType: String {
    case add = "Add car"
    case edit = "Edit details"
    var textTitle: String { return self.rawValue}
}

protocol PresentUserAlert {
    func presentAlert(errorMessage: String)
}

extension PresentUserAlert {
    func presentAlert(errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        if let vc = self as? UIViewController {
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}
