//
//  ViewController.swift
//  Todoey
//
//  Created by Ryan Finney on 7/14/18.
//  Copyright © 2018 Ryan Finney. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  var itemArray = [Item]()
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let newItem = Item(text: "Find Mike")
    itemArray.append(newItem)
    let newItem2 = Item(text: "Buy Eggos")
    itemArray.append(newItem2)
    let newItem3 = Item(text: "Destroy Demogorgon")
    itemArray.append(newItem3)
    
    if let items = defaults.array(forKey: "TodoListArray") as? [String] {
      itemArray = items
    }
  }

  //MARK - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    
    cell.textLabel?.text = itemArray[indexPath.row].title
    cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
    
    return cell
  }
  
  //MARK - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    tableView.reloadData()
  }

  //MARK - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //What will happen once the user clicks the Add Item button on our UIAlert
      if let newItemTitle = textField.text {
        if newItemTitle.count > 0 {
          let newItem = Item(text: newItemTitle)
          self.itemArray.append(newItem)
          //self.defaults.set(self.itemArray, forKey: "TodoListArray")
          self.tableView.reloadData()
        }
      }
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
}

