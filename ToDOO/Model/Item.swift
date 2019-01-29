//
//  Item.swift
//  ToDOO
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 Kedar. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object{
    @objc dynamic var name:String=""
    @objc dynamic var done:Bool=false
    var parentCategory=LinkingObjects(fromType: Category.self, property: "items")
    @objc dynamic var dateCreated:Date = Date.init()
}
