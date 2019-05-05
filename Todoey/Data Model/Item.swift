//
//  Item.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-04.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import Foundation


// Encodable - class can be encoded into plist or json; all properties must have standart data types
class Item: Codable {
    
    var title: String = ""
    var done: Bool = false

}
