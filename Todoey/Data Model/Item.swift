//
//  item.swift
//  Todoey
//
//  Created by Ryan Finney on 7/14/18.
//  Copyright © 2018 Ryan Finney. All rights reserved.
//

import Foundation

class Item {
  
  let title : String
  var done : Bool = false
  
  init(text : String) {
    
    self.title = text
  }
  
}
