//
//  ViewController.swift
//  checklist
//
//  Created by Ibrahim Wassouf on 2022-10-23.
//

import UIKit

class ChecklistViewController: UITableViewController, itemDetailViewControllerDelegate {
    var items = [ChecklistItem]()
    
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
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    //MARK: - add item viewcontroller delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPathsArray = [indexPath]
        tableView.insertRows(at: indexPathsArray, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEdittingItem item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("the document directory is: \(documentsDirectory())")
        print("file path is: \(dataFilePath())")
        
        navigationController?.navigationBar.prefersLargeTitles = true;
        loadChecklistItems()
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
    
    //function that returns the full path to the documents folder
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    //uses documentDirectory() to construct the full path to the file that will store the
    //checklist items
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription) ")
        }
        
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode(
                    [ChecklistItem].self,
                    from: data)
            } catch {
                print("Error loading item array: \(error.localizedDescription)")
            }
        }
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
            
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
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
            saveChecklistItems()
        }
}

