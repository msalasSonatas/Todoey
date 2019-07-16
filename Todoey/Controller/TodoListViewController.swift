//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Miguel Salas on 7/14/19.
//  Copyright © 2019 Miguel Salas. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //MARK: - Variables
    
    var itemArray = [ListItem]()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItems()
        
    }
    
    //MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark: - Actions
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            if let itemText = textField.text {
                let newItem = ListItem()
                newItem.title = itemText
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Private Methods
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            if let dataFilePath = self.dataFilePath {
                try data.write(to: dataFilePath)
                
            }
        } catch {
            print("Error encoding array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let dataFilePath = self.dataFilePath {
            if let data = try? Data(contentsOf: dataFilePath) {
                let decoder = PropertyListDecoder()
                do {
                    itemArray = try decoder.decode([ListItem].self, from: data)
                } catch {
                    print("Error decoding array, \(error)")
                }
            }
        }
        
    }
    
    
    
}

