//
//  Model.swift
//  RealmCarsList
//
//  Created by Дмитрий Яновский on 13.04.24.
//

import RealmSwift

class Model: Object {
    @Persisted var brand: String?
    @Persisted var model: String?
    @Persisted var year: Int16?
    @Persisted var engine: Double?
}
