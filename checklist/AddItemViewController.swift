//
//  AddItemViewController.swift
//  checklist
//
//  Created by Ibrahim Wassouf on 2022-10-25.
//

import UIKit

class AddItemViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - Actions
    
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(){
        navigationController?.popViewController(animated: true)
    }

}
