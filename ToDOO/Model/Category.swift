//
//  Category.swift
//  ToDOO
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 Kedar. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var name:String=""
    let items=List<Item>()
    
}
