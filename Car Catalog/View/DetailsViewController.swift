//
//  AboutViewController.swift
//  Car Catalog
//
//  Created by xdrond.
//  Copyright © 2020 romanromanov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITextFieldDelegate, PresentUserAlert {

    var modelController: ModelController!

    var detailsTitle: DetailsTitleType!

    weak var carForEdit: CarMO!

    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var bodyStyleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!

    @IBOutlet weak var saveButtonStyle: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        modelController = ModelController()

        guard let title = detailsTitle else { return }
        self.navigationItem.title = title.textTitle

        guard let car = carForEdit else { return }
        brandTextField.text = car.brand
        modelTextField.text = car.model
        bodyStyleTextField.text = car.bodyStyle
        yearTextField.text = car.manufactureYear

        brandTextField.delegate = self
        modelTextField.delegate = self
        bodyStyleTextField.delegate = self
        yearTextField.delegate = self

        saveButtonStyle.layer.cornerRadius = 10

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    @IBAction func saveButton(_ sender: UIButton) {
        let brand = brandTextField.text
        let model = modelTextField.text
        let body = bodyStyleTextField.text
        let year = yearTextField.text

        if !(brand!.isEmpty || model!.isEmpty) {
            if let car = carForEdit {
                car.brand = brand!
                car.model = model!
                car.bodyStyle = body
                car.manufactureYear = year
                do {
                    try modelController!.updateData(carToUpdate: car)
                } catch let error as NSError {
                    presentAlert(errorMessage: error.localizedDescription)
                }
            } else {
                do {
                    try modelController!.createCar(brand: brand!, model: model!, bodyStyle: body, manufactureYear: year)
                } catch let error as NSError {
                    presentAlert(errorMessage: error.localizedDescription)
                }
            }

        }

    }


}
