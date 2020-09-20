//
//  ViewController.swift
//  Car Catalog
//
//  Created by xdrond.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController, PresentUserAlert {

    var modelController: ModelController!

    var cars: [CarMO]?

    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = ModelController()
        do {
            try cars = modelController.retrieveAllCars()
            cars!.reverse()

        } catch let error as NSError {
            presentAlert(errorMessage: error.localizedDescription)
        }
        
        self.tableView.dataSource = self

    }


    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        switch segue.identifier {
        case Constants.editSegueID.text:
            if let detailsVC = segue.destination as? DetailsViewController {
                detailsVC.detailsTitle = .add

                // Здесь объектом sender является ячейка, на которую нажимает юзер
                // Получаем indexPath выбранной ячейки с помощью метода indexPathForCell:
                let index = self.tableView.indexPath(for: (sender as! CarTableViewCell))!.row
                detailsVC.carForEdit = cars![index]
            }
        case Constants.editSegueID.text:
            if let detailsVC = segue.destination as? DetailsViewController {
                detailsVC.detailsTitle = .edit
            }
        default:
            print("Unknown segue transition.")
        }

    }
}



extension CarsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars!.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellID.text, for: indexPath) as! CarTableViewCell

        guard let brand = self.cars?[indexPath.row].brand else { return cell }
        guard let model = self.cars?[indexPath.row].model else { return cell }

        cell.textLabel?.text = brand + " " + model

        return cell
    }

    /// Delete car
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try modelController!.deleteData(carToDelete: cars![indexPath.row])
            } catch let error as NSError {
                presentAlert(errorMessage: error.localizedDescription)
            }
            cars!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

enum Constants: String {
    case addSegueID = "addCar"
    case editSegueID = "carDetails"
    case cellID = "CarTableViewCell"
    var text: String { return self.rawValue}
}

enum DetailsTitleType: String {
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
