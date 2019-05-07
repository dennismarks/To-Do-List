//
//  Item.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-06.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var done : Bool = false
    @objc dynamic var title : String = ""
    @objc dynamic var dateCreated: Date?
    
    // define reverse relationship
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
