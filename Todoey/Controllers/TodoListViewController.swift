//
//  ViewController.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-03.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray  = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = Item()
        item.title = "Call Stella"
        
//        defaults.removeObject(forKey: "TodoItemArray")
//        UserDefaults.standard.synchronize()
        
        if let items = defaults.array(forKey: "TodoItemArray") as? [Item] {
            itemArray = items
        }
    }
    
    // MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoItemArray")
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
}
