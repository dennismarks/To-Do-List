//
//  Category.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-06.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    
    // define forward relationship
    let items = List<Item>()
    
}
