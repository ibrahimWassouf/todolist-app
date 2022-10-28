//
//  ViewController.swift
//  checklist
//
//  Created by Ibrahim Wassouf on 2022-10-23.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    var items = [ChecklistItem]()
    
    //MARK: - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        }
    }
    //MARK: - add item viewcontroller delegates
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPathsArray = [indexPath]
        tableView.insertRows(at: indexPathsArray, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)
        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)
        let item3 = ChecklistItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        items.append(item3)
        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)
        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        items.append(item5)
        
        navigationController?.navigationBar.prefersLargeTitles = true;
    }
    
    //MARK: - TABLE VIEW Data Source
    //creates the number of rows in the table view - this method takes the number of rows from our model (the array instantiated above) and sends it to the view
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
    
    //updates the cell in the table view to use the data at the corresponding row; also allows for cells to be reused.
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ChecklistItem",
                for: indexPath)
            
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
            return cell
        }
    
    //MARK: - Table View Delegate
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem){
            if item.checked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    
    //method that toggles the checkmark on or off when user taps
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem){
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = item.text
        }
    
    override func tableView(
        _ tableView: UITableView,
        commit edittingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath){
            items.remove(at: indexPath.row)
            
            let indexPathArray = [indexPath]
            tableView.deleteRows(at: indexPathArray, with: .automatic)
        }
}

