//
//  ViewController.swift
//  Todoey
//
//  Created by Ryan Finney on 7/14/18.
//  Copyright © 2018 Ryan Finney. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

  //var itemArray = [Item]()
  let realm = try! Realm()
  var items: Results<Item>?
  var selectedCategory : Category? {
    didSet{
      loadItems()
    }
  }
  var selectedCategoryName : String = ""
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    //loadItems()
    tableView.separatorStyle = .none
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationItem.title = selectedCategory?.name ?? "Unknown"
//    if let colorHex = selectedCategory?.color {
//      navigationController?.navigationBar.barTintColor = UIColor(hexString: colorHex)
//      if let backgroundColor = navigationController?.navigationBar.barTintColor {
//        let textColor = ContrastColorOf(backgroundColor, returnFlat: true)
//        searchBar.barTintColor = backgroundColor
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: textColor]
//        navigationController?.navigationBar.tintColor = textColor
//      }
//    }
    updateNavBar(withHexCode: selectedCategory?.color ?? defaultNavBarColor)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    updateNavBar(withHexCode: defaultNavBarColor)
  }
  
  //MARK: Nav Bar Setup Methods
  
  func updateNavBar(withHexCode colorString: String) {
    
    guard let navBar = navigationController?.navigationBar else { return }
    guard let bgColor = UIColor(hexString: colorString) else { return }
    let textColor = ContrastColorOf(bgColor, returnFlat: true)
    
    navBar.barTintColor = bgColor
    searchBar.barTintColor = bgColor
    navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: textColor]
    navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: textColor]
    navBar.tintColor = textColor
    
  }

  //MARK - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return items?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let item = items?[indexPath.row] {
      cell.textLabel?.text = item.title
      if let bgColor = UIColor(hexString: (self.selectedCategory!.color))?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(items!.count)) / 2) {
        cell.backgroundColor = bgColor
        cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
        cell.accessoryType = item.done ? .checkmark : .none
      }
    } else {
      cell.textLabel?.text = "No Items Added"
    }
    
    //cell.textLabel?.text = itemArray[indexPath.row].title
    //cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
    
    return cell
  }
  
  //MARK - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = items?[indexPath.row] {
      do {
        try realm.write {
          item.done = !item.done
        }
      } catch {
        print("Error saving done status, \(error)")
      }
    }
    
    //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    //context.delete(itemArray[indexPath.row])
    //itemArray.remove(at: indexPath.row)
    
//    self.saveItems()
//
    tableView.deselectRow(at: indexPath, animated: true)

    tableView.reloadData()
  }

  //MARK - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    //print(sender)
    
    let alert = UIAlertController(title: "Add New \(selectedCategoryName) Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //What will happen once the user clicks the Add Item button on our UIAlert
      if let newItemTitle = textField.text {
        if newItemTitle.count > 0 {
          //let newItem = Item(context: self.context)
          //newItem.title = newItemTitle
          //newItem.parentCategory = self.selectedCategory
          //self.itemArray.append(newItem)
          //self.saveItems()
          //self.tableView.reloadData()
          let newItem = Item()
          newItem.title = newItemTitle
          newItem.done = false
          newItem.dateCreated = Date()
          self.saveItems(item: newItem)
        }
      }
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
      return
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    alert.addAction(action)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }
  
  //MARK - Save Data
  func saveItems(item: Item) {
    
    if let currentCategory = self.selectedCategory {
      do {
        try realm.write {
          currentCategory.items.append(item)
        }
      } catch {
        print("Error saving new item: \(error)")
      }
    }
    
    
//    do {
//      try context.save()
//    } catch {
//      print("Error saving context: \(error)")
//    }
    
    tableView.reloadData()
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
//  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicatedBy predicateArray: [NSPredicate] = []) {
  func loadItems() {
    //items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
//    let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//    let predicates = predicateArray + [predicate]
//    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
//
//    //let request : NSFetchRequest<Item> = Item.fetchRequest()
//    do {
//      itemArray = try context.fetch(request)
//    } catch {
//      print("Error fetching items: \(error)")
//    }
    
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
  
  override func updateModels(at indexPath: IndexPath) {
    if let item = items?[indexPath.row] {
      do {
        try realm.write {
          realm.delete(item)
        }
      } catch {
        print("Error deleting item: \(error)")
      }
    }
  }
  
}

//MARK - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if searchBar.text! == "" {
      resignSearchBar(on: searchBar)
      return
    }
    items = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//    let request : NSFetchRequest<Item> = Item.fetchRequest()
//    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//    loadItems(with: request, predicatedBy: [predicate])
    tableView.reloadData()
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

