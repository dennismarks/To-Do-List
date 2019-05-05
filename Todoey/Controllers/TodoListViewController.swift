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
    
    // create a filepath to the Documents folder; userDomainMask - place where we save personal items associated with current app; create Items.plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
//        defaults.removeObject(forKey: "TodoItemArray")
//        UserDefaults.standard.synchronize()
        
//        if let items = defaults.array(forKey: "TodoItemArray") as? [Item] {
//            itemArray = items
//        }
    }
    
    // MARK - TableView Datasource Methods
    
    // return a new cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
    
        return cell
    }
    
    // return number of times in an array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK - TableView Delegate Methods
    
    // The user selects the row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - add new item
    
    // The user presses the add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // save new item in the user defaults
            //self.defaults.set(self.itemArray, forKey: "TodoItemArray")
            
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
    
    // Encode data
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            // encode data
            let data = try encoder.encode(itemArray)
            // write data to data path
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
        tableView.reloadData()
    }
    
    // Decode datas
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }
}
