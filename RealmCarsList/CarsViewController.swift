//
//  CarsViewController.swift
//  RealmCarsList
//
//  Created by Дмитрий Яновский on 13.04.24.
//
protocol CarsViewControllerDelegate: AnyObject {
    func didAddCar()
}

import UIKit

class CarsViewController: UIViewController {
    
    weak var delegate: CarsViewControllerDelegate?
    var selectedCar: Model?
    
    // Создаем текстовые поля для ввода данных
    let brandTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Brand"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let modelTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Model"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let yearTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Year"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let engineCapacityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Engine Capacity"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSelectedCar()
        view.backgroundColor = .white
        self.title = "Create Car"
        
        // Добавляем текстовые поля на экран
        view.addSubview(brandTextField)
        view.addSubview(modelTextField)
        view.addSubview(yearTextField)
        view.addSubview(engineCapacityTextField)
        
        setupLayout()
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeModalView))
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createCar))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
    // отображение данных выбранной машины
    func viewSelectedCar() {
        if let selectedCar = selectedCar {
            brandTextField.text = selectedCar.brand
            modelTextField.text = selectedCar.model
            if let year = selectedCar.year {
                yearTextField.text = String(year)
            }
            if let engine = selectedCar.engine {
                engineCapacityTextField.text = String(engine)
            }
        }
    }
    // Функция для установки расположения текстовых полей на экране
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [brandTextField, modelTextField, yearTextField, engineCapacityTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    // фуникция сохрания
    func saveCar() -> Bool {
        guard let brand = brandTextField.text,
              let model = modelTextField.text,
              let yearString = yearTextField.text,
              let year = Int16(yearString),
              let engineCapacityString = engineCapacityTextField.text,
              let engineCapacity = Double(engineCapacityString) else {
            
            let alertController = UIAlertController(title: "Errors", message: "All fields are required", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertController, animated: true)
            return false
        }
            // обновление сущесвующей машины
        if let selectedCar = selectedCar{
            RealmManager.shared.updateCar(car: selectedCar, brand: brand, model: model, year: year, engine: engineCapacity)
        } else {
            
            // Добавляем новый обьект Model в базу данных Realm с помощью менеджера
            RealmManager.shared.addCar(brand: brand, model: model, year: year, engine: engineCapacity)
        }
            return true
    }
    
    
    @objc func closeModalView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createCar() {
        if saveCar() {
            dismiss(animated: true, completion: nil)
            delegate?.didAddCar()
            
            
        }
    }
}









