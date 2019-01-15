//
//  ViewController.swift
//  ToDOO
//
//  Created by Apple on 09/01/19.
//  Copyright © 2019 Kedar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray=[String]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = defaults.array(forKey: "ToDoListArray") as? [String]{
            itemArray=item
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[(indexPath.row)])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
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
            self.itemArray.append(textField.text!)
                
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
            }
        }
        uiAlertController.addTextField { (AlertTextField) in
            AlertTextField.placeholder="Enter new item"
            textField=AlertTextField
        }
        uiAlertController.addAction(uiAlertAction)
        self.present(uiAlertController, animated: true, completion: nil)
        
    }
    
}

