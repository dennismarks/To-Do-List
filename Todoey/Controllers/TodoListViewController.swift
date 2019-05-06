//
//  ViewController.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-03.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray  = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        setUpSearchController()
    }
    
    // MARK: - TableView Datasource Methods
    
    // return a new cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
    
        return cell
    }
    
    // Return number of items in an array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: - TableView Delegate Methods
    
    // The user selects the row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         // update item
//         itemArray[indexPath.row].setValue("newTitle", forKey: "title")
        
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
         // remove item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: – add new item
    
    // The user presses the add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
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
    
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    // with – external parametr; request - interanl; if argument is not provided then NSFetchRequest will be set to Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()

    }
    
}

extension TodoListViewController: UISearchResultsUpdating {
    
    func setUpSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self as? UISearchBarDelegate
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        if searchText == "" {
            loadItems(with: request)
        } else {
            // predicate specifies how we want to query our database
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            // sort the data
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
        }
    }
    
}

// MARK: - search bar methods
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // predicate specifies how we want to query our database
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // sort the data
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//    }
//
////    func searchBarCancelButtonClicked(_ searchBar: UISearschBar) {
////        searchBar.text = ""
////        loadItems()
////        // close keyboard and dismiss search aresa
////        DispatchQueue.main.async {
////            searchBar.resignFirstResponder()
////        }
////    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
////        searchBar.showsCancelButton = true
//        if searchBar.text?.count == 0 {
//            loadItems()
//        } else {
//            searchBarSearchButtonClicked(searchBar)
//        }
//    }
//}
