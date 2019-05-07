//
//  ViewController.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-03.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var toDoItems: List<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView Datasource Methods
    
    // return a new cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
    
        return cell
    }
    
    // Return number of items in an array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    // MARK: - TableView Delegate Methods
    
    // The user selects the row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update data using realm
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    // delete item form realm database
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        // calls cell for row
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: – add new item
    
    // The user presses the add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            if let currentCategory = self.selectedCategory {
                do {
                    // add data
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        // add is not needed BC we're using currentCategory's items instead; theya re connected
                        // self.realm.add(newItem)
                    }
                } catch {
                    print("Error when saving new item to Realm \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Success")
        }

        alert.addAction(actionCancel)
        alert.addAction(actionAdd)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model Manipulation Methods
    
    func loadItems() {
        toDoItems = selectedCategory?.items
        tableView.reloadData()
    }

}
    
//}

//extension TodoListViewController: UISearchResultsUpdating {
//    
//    func setUpSearchController() {
//        navigationItem.searchController = searchController
//        searchController.searchBar.delegate = self as? UISearchBarDelegate
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
    
//    private func filterContentForSearchText(_ searchText: String) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        if searchText == "" {
//            loadItems(with: request)
//        } else {
//            // predicate specifies how we want to query our database
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
//
//            // sort the data
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadItems(with: request, predicate: predicate)
//        }
//    }
    
//}
