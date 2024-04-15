//
//  CarsListTableViewController.swift
//  RealmCarsList
//
//  Created by Дмитрий Яновский on 13.04.24.
//

//
//  CarsListTableViewController.swift
//  CoreDataCars
//
//  Created by Дмитрий Яновский on 8.04.24.
//

import UIKit
import RealmSwift

class CarsListTableViewController: UITableViewController {
    
    struct Constant {
        static let nameTable = "Cars List"
        static let cellName = "Cell"
        static let identifierCarsView = "navController"
    }
    
    var cars: Results<Model>?
    let realm = try! Realm() // Доступ к базе
    var navController = UINavigationController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = Constant.nameTable
        navigationController?.navigationBar.prefersLargeTitles = true
       
        // Регистрируем ячейку для использования в таблице
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.cellName)
        setupAddButton()
        // Удаление линий в таблице
        tableView.tableFooterView = UIView()
        loadCars()
   
    }
    // MARK: - Setup UI
    func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTap))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
  
    
    @objc func addButtonTap() {
       
        let CarVC = CarsViewController()
        CarVC.delegate = self
        navController = UINavigationController(rootViewController: CarVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
        
        
    }
    
    func sectionIndexTitles() -> [String] {
        guard let cars = cars else { return [] }
        let brands = cars.compactMap { $0.brand }
        let uniqueFirstLetters = Set(brands.map { $0.prefix(1).uppercased() })
        return Array(uniqueFirstLetters).sorted()
    }
    // MARK: - Data Handling
    func loadCars() {
        cars = RealmManager.shared.getAllCars().sorted(byKeyPath: "brand")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return cars?.count ?? 0
        
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellName, for: indexPath)
        
         if let car = cars?[indexPath.row] {
             cell.textLabel?.text = "\(car.brand ?? "") \(car.model ?? "")"
         }
         
         return cell
     }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let selectedCar = cars?[indexPath.row] {
            let carVC = CarsViewController()
            carVC.selectedCar = selectedCar
            carVC.delegate = self
            navController = UINavigationController(rootViewController: carVC)
            navController.modalPresentationStyle = .pageSheet
            present(navController, animated: true)
        }
    }
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let carToDelete = cars?[indexPath.row] {
                    do {
                        try realm.write {
                            realm.delete(carToDelete)
                        }
                        loadCars()
                    }
                    catch {
                        print("Erorrs deleting car: \(error)")
                    }
                }
            }
        }
    }

extension CarsListTableViewController: CarsViewControllerDelegate {
    func didAddCar() {
         loadCars()
    }
}

