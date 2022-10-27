//
//  AddItemViewController.swift
//  checklist
//
//  Created by Ibrahim Wassouf on 2022-10-25.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - Actions
    
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(){
        print(textField.text!);
        navigationController?.popViewController(animated: true)
    }

    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return nil;
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        textField.becomeFirstResponder();
    }
    
    //MARK: - textField delegate
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        //figures out what the new text will be
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
}
