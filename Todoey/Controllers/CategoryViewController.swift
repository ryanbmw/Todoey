//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ryan Finney on 7/15/18.
//  Copyright © 2018 Ryan Finney. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
  
  //var categoryArray = [Category]()
  //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let realm = try! Realm()
  var categories: Results<Category>?

  override func viewDidLoad() {
    super.viewDidLoad()

    loadCategories()
        
  }
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    //return categoryArray.count
    return categories?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    //cell.textLabel?.text = categoryArray[indexPath.row].name
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
    return cell
  }
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      //What will happen once the user clicks the Add Item button on our UIAlert
      if let newCategoryName = textField.text {
        if newCategoryName.count > 0 {
          let newCategory = Category()
          newCategory.name = newCategoryName
          //let newCategory = Category(context: self.context)
          //newCategory.name = newCategoryName
          //self.categoryArray.append(newCategory)
          self.saveCategories(category: newCategory)
        }
      }
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
      self.loadCategories()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }
    alert.addAction(cancel)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  
  //MARK: - Data Manipulation Methods
  
  //MARK - Save Data
  func saveCategories(category: Category) {
    
    do {
      //try context.save()
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving context: \(error)")
    }
    
    loadCategories()
    
  }
  
  //MARK - Retrieve Data
/*  func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    
    do {
      categoryArray = try context.fetch(request)
    } catch {
      print("Error fetching items: \(error)")
    }
    
    tableView.reloadData()
  }*/
  
  func loadCategories() {
    categories =  realm.objects(Category.self)
    tableView.reloadData()
  }
  
  
  //MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "goToItems", sender: self)
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
    
    //if let indexPath = tableView.indexPathForSelectedRow {
    //  destinationVC.selectedCategory = categoryArray[indexPath.row]
    //}
  }
}
