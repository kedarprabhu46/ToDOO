//
//  ViewController.swift
//  ToDOO
//
//  Created by Apple on 09/01/19.
//  Copyright © 2019 Kedar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray=[Item]()
    let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadData()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row].title
        if itemArray[indexPath.row].checked==true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[(indexPath.row)])
        
        if itemArray[indexPath.row].checked==false{
            itemArray[indexPath.row].checked=true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else{
            itemArray[indexPath.row].checked=false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
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
                
                let newItem=Item()
            newItem.title=textField.text!
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }
        catch{
            print(error)
        }
    }
    
    func loadData(){
        if let data=try? Data(contentsOf: dataFilePath!){
            let dataDecoder = PropertyListDecoder()
            do{
                itemArray=try dataDecoder.decode([Item].self, from: data)
            // tableView.reloadData()
            }
            catch{}
        }
    }
    
}

