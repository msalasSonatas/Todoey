//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Miguel Salas on 7/16/19.
//  Copyright © 2019 Miguel Salas. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }
    
    //MARK: - Functions
    
    func saveData(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category into Realm, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }

    //MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            if let itemText = textField.text {
                
                let newCategory = Category()
                newCategory.name = itemText
    
                self.saveData(category: newCategory)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: -  Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
        }

        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
}
