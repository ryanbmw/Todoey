//
//  Category.swift
//  Todoey
//
//  Created by Ryan Finney on 7/15/18.
//  Copyright © 2018 Ryan Finney. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  
  @objc dynamic var name : String = ""
  @objc dynamic var color : String = ""
  let items = List<Item>()
}
