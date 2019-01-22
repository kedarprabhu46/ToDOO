//
//  CategoryViewController.swift
//  ToDOO
//
//  Created by Apple on 20/01/19.
//  Copyright © 2019 Kedar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text=categoryList[indexPath.row].name
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
            destinationVC.selectedCategory=categoryList[indexPath.row]
        }
    }
    
    func loadCategories(){
        let request:NSFetchRequest<Category>=Category.fetchRequest()
        do{
            categoryList=try context.fetch(request)
        }
        catch{
            print("error fetching\(error)")
        }
        tableView.reloadData()
    }
    
    
    func saveCategory(){
        do{
            try context.save()
            
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
                let newCategory=Category(context: self.context)
                newCategory.name=textField.text
                self.categoryList.append(newCategory)
                print("$$$$$$$saved")
                
                self.saveCategory()
            }
        }
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
