//
//  Category.swift
//  Todoey
//
//  Created by Miguel Salas on 7/17/19.
//  Copyright © 2019 Miguel Salas. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()

}
