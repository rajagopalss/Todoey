//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rajagopal Srinivasan on 2/21/18.
//  Copyright © 2018 Rajagopal Srinivasan. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var ctgArray = [Category]()
    
    var defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }

   
    //MARK: - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ctgArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = ctgArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
             let category = ctgArray[indexPath.row]
            
            destinationVC.selectedCategory = category
            
            
        }
    }
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action =    UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCtg = Category(context: self.context)
            
            newCtg.name = textField.text!
            
            self.ctgArray.append(newCtg)
            self.saveCategory()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save Method
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving category in context, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Load Method
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            ctgArray = try context.fetch(request)
        } catch {
            print("Error fetching Category from context, \(error)")
        }
    }
    
}
