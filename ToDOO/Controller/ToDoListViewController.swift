//
//  ViewController.swift
//  ToDOO
//
//  Created by Apple on 09/01/19.
//  Copyright © 2019 Kedar. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray=[Item]()
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        searchBar.delegate=self
        //searchBar.showsCancelButton=true
       // loadData()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row].title
        if itemArray[indexPath.row].done==true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[(indexPath.row)])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        
        let uiAlertController=UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let uiAlertAction=UIAlertAction.init(title: "Add", style: .default) { (AlertAction) in
            print(textField.text!)
            if textField.text==""{
                let errorAlertController=UIAlertController(title: "No item entered", message: "Enter an item", preferredStyle: UIAlertControllerStyle.alert)
                let errorAction=UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                errorAlertController.addAction(errorAction)
                self.present(errorAlertController, animated: true, completion: nil)
            }
            else{
                
                let newItem=Item(context: self.context)
            newItem.title=textField.text!
                newItem.done=false
                newItem.parentCategory=self.selectedCategory
            self.itemArray.append(newItem)
                
                self.saveItems()
            self.tableView.reloadData()
                print(self.itemArray)
            }
        }
        uiAlertController.addTextField { (AlertTextField) in
            AlertTextField.placeholder="Enter new item"
            textField=AlertTextField
        }
        uiAlertController.addAction(uiAlertAction)
        self.present(uiAlertController, animated: true, completion: nil)
        
    }
    func saveItems()
    {
       do{
            try context.save()
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Item>=Item.fetchRequest()
        request.predicate=NSPredicate.init(format: "parentCategory.name == %@", selectedCategory!.name!)
        do{
            itemArray=try context.fetch(request)
        }
        catch{
            print("fetch error\(error)")
        }
    }
    
    
}

extension ToDoListViewController:UISearchBarDelegate{
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search clicked")
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        
        let predicateCategory=NSPredicate(format: "parentCategory.name == %@", selectedCategory!.name!)
        let predicateSearch = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text!)
        
        let compoundPred = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCategory,predicateSearch])
        request.predicate=compoundPred
        
        
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            
        }
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


