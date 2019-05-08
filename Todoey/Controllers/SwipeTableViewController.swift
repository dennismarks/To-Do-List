//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-07.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

class SwipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.updateModule(at: indexPath)
            completion(true)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func updateModule(at indexPath: IndexPath) {
        
    }
    
}
