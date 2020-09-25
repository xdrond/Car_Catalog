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
    @IBOutlet weak var lastChangeLabel: UILabel!

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
            updateLastChangeLabel(newDate: car.lastChange)
        }

        brandTextField.delegate = self
        modelTextField.delegate = self
        bodyStyleTextField.delegate = self
        yearTextField.delegate = self

        hideKeyboardWhenTappedAround()

        saveButtonStyle.layer.cornerRadius = 10

    }

    override func viewDidAppear(_ animated: Bool) {
        switch detailsTitle! {
        case .add:
            lastChangeLabel.isHidden = true
        case .edit:
            lastChangeLabel.isHidden = false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }


    @IBAction func saveButton(_ sender: UIButton) {

        let brand = brandTextField.text!
        let model = modelTextField.text!
        let body = bodyStyleTextField.text!
        let year = yearTextField.text!

        if brand.isEmpty || model.isEmpty {
            presentAlert(errorMessage: "Brand and model cannot be missing!")
            return
        }

        guard let modelController = modelController else { return }
            switch detailsTitle! {
            case .add:
                modelController.createCar(brand: brand,
                                          model: model,
                                          bodyStyle: body,
                                          manufactureYear: year)
            case .edit:
                if let carForEdit = carForEdit {
                    carForEdit.brand = brand
                    carForEdit.model = model
                    carForEdit.bodyStyle = body
                    carForEdit.manufactureYear = year
                    carForEdit.lastChange = Date()
                    modelController.saveContext()
                    updateLastChangeLabel(newDate: carForEdit.lastChange)
                }
            }

    }

    func updateLastChangeLabel(newDate: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        lastChangeLabel.text! = "Last change: " + formatter.string(from: newDate)
    }

}

extension DetailsViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}
