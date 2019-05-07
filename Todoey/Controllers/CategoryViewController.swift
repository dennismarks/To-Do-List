//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-05.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        loadCategory()
        setUpSearchController()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "Press the + button to add your first category!"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // nil coalescing operator - if categoryArray is nil return 1 else count
        return categoryArray?.count ?? 1
    }
    
    
    // MARK: – Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("Success")
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Success")
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionAdd)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
}


extension CategoryViewController: UISearchResultsUpdating {

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
//        if searchText ==
        if searchText == "" {
            loadCategory()
        } else {
//            print("HERE2")
            print(searchText)
            categoryArray = categoryArray?.filter("name CONTAINS[cd] %@", searchText)
            self.tableView.reloadData()
        }
    }

}
