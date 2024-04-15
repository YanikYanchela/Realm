//
//  RealmManager.swift
//  RealmCarsList
//
//  Created by Дмитрий Яновский on 13.04.24.
//
import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager() // синглетон
    
    private let realm: Realm
    
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to instantiate Realm database: \(error)")
        }
    }
    // MARK: - CRUD
    
    // Create
    func addCar(brand: String, model: String, year: Int16, engine: Double) {
        let car = Model()
        car.brand = brand
        car.model = model
        car.year = year
        car.engine = engine
        
        do  {
            try realm.write {
                realm.add(car)
            }
        } catch {
            print("Error adding car: \(error)")
        }
    }
    // Read
    func getAllCars() -> Results<Model> {
        return realm.objects(Model.self)
    }
    
    // Update
    func updateCar(car: Model, brand: String, model: String, year: Int16, engine: Double) {
        do {
            try realm.write {
                car.brand = brand
                car.model = model
                car.year = year
                car.engine = engine
            }
        } catch {
            print("Error updating car: \(error)")
        }
    }
    
    // Delete
    func deleteCar(car: Model) {
        do {
            try realm.write {
                realm.delete(car)
            }
        } catch {
            print("Error deleting car: \(error)")
        }
    }
}




