//
//  CategoryViewController.swift
//  ToDOO
//
//  Created by Apple on 20/01/19.
//  Copyright © 2019 Kedar. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm=try! Realm()
    var categoryList: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text=categoryList?[indexPath.row].name ?? "No categories added"
        cell.backgroundColor=UIColor.cyan
        return cell
    }
    
    //MARK:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryListSeque", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath=tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory=categoryList?[indexPath.row]
        }
    }
    
    func loadCategories(){
        
        categoryList=realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    func saveCategory(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
            
        }
        catch{
            print("Error saving\(error)")
        }
        tableView.reloadData()
    }
    
    
    @IBAction func AddCategory(_ sender: Any) {
        
        var textField = UITextField()
        let alertController=UIAlertController(title: "New Category", message: "Add new Category", preferredStyle: .alert)
        alertController.addTextField { (TextField) in
            TextField.placeholder="Category name"
            textField=TextField
        }
        let alertAction=UIAlertAction(title: "Add", style: .default) { (AlertAction) in
            if (textField.text) != ""{
                print("$$$$$$$$$saving")
                let newCategory=Category()
                newCategory.name=textField.text!
                print("$$$$$$$saved")
                
                self.saveCategory(category: newCategory)
            }
        }
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
