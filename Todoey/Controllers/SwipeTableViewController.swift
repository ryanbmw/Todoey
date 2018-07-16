//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Ryan Finney on 7/15/18.
//  Copyright © 2018 Ryan Finney. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  
  let defaultNavBarColor : String = "#0096FF"

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 70
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
    
    cell.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      //print("Item deleted: \(self.categories?[indexPath.row].name)")
      print("Delete cell")
      self.updateModels(at: indexPath)
//      if let category = self.categories?[indexPath.row] {
//        self.delete(category: category)
//      }
    }
    
    // customize the action appearance
    deleteAction.image = UIImage(named: "delete-icon")
    
    return [deleteAction]
  }
  
  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    //options.transitionStyle = .border
    return options
  }
  
  func updateModels(at indexPath: IndexPath) {
    //update data model
  }


}
