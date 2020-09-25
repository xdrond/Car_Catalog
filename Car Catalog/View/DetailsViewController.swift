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

        if let car = carForEdit {
            brandTextField.text = car.brand
            modelTextField.text = car.model
            bodyStyleTextField.text = car.bodyStyle
            yearTextField.text = car.manufactureYear
        }

        brandTextField.delegate = self
        modelTextField.delegate = self
        bodyStyleTextField.delegate = self
        yearTextField.delegate = self

        saveButtonStyle.layer.cornerRadius = 10

    }

    override func viewDidDisappear(_ animated: Bool) {
        do {
            try carForEdit!.managedObjectContext?.save()
        } catch let error as NSError {
            print(error)
        }
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
        if let modelController = modelController {
            switch detailsTitle! {
            case .add:
                modelController.createCar(brand: brand!,
                                          model: model!,
                                          bodyStyle: body,
                                          manufactureYear: year)
            case .edit:
                if let carForEdit = carForEdit {
                    carForEdit.brand = brand!
                    carForEdit.model = model!
                    carForEdit.bodyStyle = body
                    carForEdit.manufactureYear = year
                }
            }
        }

    }


}
