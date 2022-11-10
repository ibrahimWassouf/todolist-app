//
//  DataModel.swift
//  checklist
//
//  Created by Ibrahim Wassouf on 2022-11-09.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
    }
    
    //MARK: - Data Saving
    //function that returns the full path to the documents folder
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    //uses documentDirectory() to construct the full path to the file that will store the
    //checklist checklist.items
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription) ")
        }
        
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode(
                    [Checklist].self,
                    from: data)
            } catch {
                print("Error loading item array: \(error.localizedDescription)")
            }
        }
    }
}
