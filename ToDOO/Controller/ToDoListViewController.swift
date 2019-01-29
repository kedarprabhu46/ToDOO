//
//  ViewController.swift
//  ToDOO
//
//  Created by Apple on 09/01/19.
//  Copyright © 2019 Kedar. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var itemArray:Results<Item>?
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
 
    let realm=try? Realm()
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        searchBar.delegate=self
        
        
        //searchBar.showsCancelButton=true
       // loadData()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray?[indexPath.row].name ?? ""
        if itemArray?[indexPath.row].done==true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray![(indexPath.row)])
        
        if let item=itemArray?[indexPath.row]
        {
            do{
                try realm?.write {
                    item.done = !item.done
                }
            }
            catch{
                
            }
            
        }
        tableView.reloadData()
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
                
                do{
                    try self.realm?.write{
                let newItem=Item()
                newItem.done=false
                newItem.name=textField.text!
                self.selectedCategory?.items.append(newItem)
                    }
                }
                catch{
                    
                }
                
                
                self.tableView.reloadData()
//                print(self.itemArray)
            }
        }
        uiAlertController.addTextField { (AlertTextField) in
            AlertTextField.placeholder="Enter new item"
            textField=AlertTextField
        }
        uiAlertController.addAction(uiAlertAction)
        self.present(uiAlertController, animated: true, completion: nil)
        
    }

    func loadData(){
        itemArray=selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    
}

extension ToDoListViewController:UISearchBarDelegate{



    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search clicked")

//        itemArray = itemArray?.filter(NSPredicate(format: "name CONTAINS[c] %@", searchBar.text!)).sorted(byKeyPath: "name", ascending: true)
        itemArray = itemArray?.filter(NSPredicate(format: "name CONTAINS[c] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            
            print("clear text clicked")
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


