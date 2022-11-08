//
//  AllListsViewController.swift
//  checklist
//
//  Created by Ibrahim Wassouf on 2022-11-07.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    let cellIdentifier = "ChecklistCell"
    var lists = [Checklist]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Things")
        lists.append(list)

        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        navigationController?.navigationBar.prefersLargeTitles = true;
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath)
            var data = lists[indexPath.row]
            cell.textLabel!.text = data.name
            cell.accessoryType = .detailDisclosureButton
            
            return cell
        }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "ShowChecklist", sender: lists[indexPath.row])
        }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            lists.remove(at: indexPath.row)
            
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    
    //MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist) {
            if let index = lists.firstIndex(of: checklist){
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.textLabel!.text = checklist.name
                }
            }
            navigationController?.popViewController(animated: true)
        }
    
    
    
}
