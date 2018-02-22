//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rajagopal Srinivasan on 2/21/18.
//  Copyright © 2018 Rajagopal Srinivasan. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var ctgArray = [Category]()
    var defaults = UserDefaults.standard
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }

   
    //MARK: - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // nil coallasing operator if nil return 1
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        //let category = ctgArray[indexPath.row]
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added"
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
    

        if let indexPath = tableView.indexPathForSelectedRow {

            

            destinationVC.selectedCategory = categories?[indexPath.row]
            
            


        }
    }
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action =    UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCtg = Category()
            
            newCtg.name = textField.text!
            
            self.ctgArray.append(newCtg)
            self.saveCategory(category: newCtg)
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
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
                }
        } catch {
            print("Error saving category in context, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Load Method
    
    func loadCategory() {

        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
}
