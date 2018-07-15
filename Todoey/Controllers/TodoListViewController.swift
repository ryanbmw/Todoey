//
//  ViewController.swift
//  Todoey
//
//  Created by Ryan Finney on 7/14/18.
//  Copyright © 2018 Ryan Finney. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

  var itemArray = [Item]()
  var selectedCategory : Category? {
    didSet{
      loadItems()
    }
  }
  
  //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = selectedCategory!.name
    //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    //loadItems()
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
    //context.delete(itemArray[indexPath.row])
    //itemArray.remove(at: indexPath.row)
    self.saveItems()
    
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
          let newItem = Item(context: self.context)
          newItem.title = newItemTitle
          newItem.parentCategory = self.selectedCategory
          self.itemArray.append(newItem)
          self.saveItems()
          //self.tableView.reloadData()
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
  
  //MARK - Save Data
  func saveItems() {
    
    do {
      try context.save()
    } catch {
      print("Error saving context: \(error)")
    }
    
    self.tableView.reloadData()
//    let encoder = PropertyListEncoder()
//
//    do {
//      let data = try encoder.encode(itemArray)
//      try data.write(to: dataFilePath!)
//    } catch {
//      print("Error encoding itemArray: \(error)")
//    }
    
  }
  
  //MARK - Retrieve Data
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicatedBy predicateArray: [NSPredicate] = []) {
    
    let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    let predicates = predicateArray + [predicate]
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    
    //let request : NSFetchRequest<Item> = Item.fetchRequest()
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching items: \(error)")
    }
    
//    if let data = try? Data(contentsOf: dataFilePath!) {
//      let decoder = PropertyListDecoder()
//      do {
//        itemArray = try decoder.decode([Item].self, from: data)
//      } catch {
//        print("Error decoding itemArray: \(error)")
//      }
//    }
    tableView.reloadData()
  }
  
  
}

//MARK - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadItems(with: request, predicatedBy: [predicate])
    resignSearchBar(on: searchBar)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      
      resignSearchBar(on: searchBar)
    }
  }
  
  func resignSearchBar(on searchBar: UISearchBar) {
    DispatchQueue.main.async {
      searchBar.resignFirstResponder()
    }
  }
  
}

