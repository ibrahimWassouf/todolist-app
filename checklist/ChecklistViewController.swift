//
//  ViewController.swift
//  checklist
//
//  Created by Ibrahim Wassouf on 2022-10-23.
//

import UIKit

class ChecklistViewController: UITableViewController, itemDetailViewControllerDelegate {
    var checklist: Checklist!
    
    //MARK: - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = checklist.name
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - add item viewcontroller delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPathsArray = [indexPath]
        tableView.insertRows(at: indexPathsArray, with: .automatic)
        navigationController?.popViewController(animated: true)

    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEdittingItem item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
   
    //MARK: - TABLE VIEW Data Source
    //creates the number of rows in the table view - this method takes the number of rows from our model (the array instantiated above) and sends it to the view
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return checklist.items.count
        }
    
    //updates the cell in the table view to use the data at the corresponding row; also allows for cells to be reused.
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ChecklistItem",
                for: indexPath)
            
            let item = checklist.items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
            return cell
        }
    
    //MARK: - Table View Delegate
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem){
            let label = cell.viewWithTag(1001) as! UILabel
            if item.checked {
                label.text = "√"
            } else {
                label.text = ""
            }
        }
    
    //method that toggles the checkmark on or off when user taps
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem){
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "\(item.itemID): \(item.text)"
        }
    
    override func tableView(
        _ tableView: UITableView,
        commit edittingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath){
            checklist.items.remove(at: indexPath.row)
            
            let indexPathArray = [indexPath]
            tableView.deleteRows(at: indexPathArray, with: .automatic)
        }
}

