//
//  ViewController.swift
//  Todoey
//
//  Created by Rajagopal Srinivasan on 2/20/18.
//  Copyright © 2018 Rajagopal Srinivasan. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class TodoListViewController: UITableViewController {

//    var itemArray = ["Costco", "Walmart", "Giant"]

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

//     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.




        //loadItems()


    }

    //MARK - Tableview DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

        if let item = todoItems?[indexPath.row] {

            cell.textLabel?.text = item.title

            //using ternary operator to refactor
            // value = condition ? valueIfTrue : ValueIfFase

            cell.accessoryType =  item.done == true ?  .checkmark : .none

        }
        else {
            cell.textLabel?.text = "No Items added"
        }

        return cell
    }

    //MARK = Tablview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating items \(error)")
            }
        }
        self.tableView.reloadData()
    }
    
    

    //MARK - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in


            //Saving in reverse way for the relationship where category has items
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.createdDate = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saiving items \(error)")
                }
            }
            

            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }

    func saveItems() {
        
    }

    func loadItems() {

        todoItems = realm.objects(Item.self)
        tableView.reloadData()
    }




}

//MARK: - Extension for Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "(parentCategory.name MATCHES %@)", selectedCategory!.name!)
//
//            loadItems(with: request, predicate: predicate)
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
    }
}


