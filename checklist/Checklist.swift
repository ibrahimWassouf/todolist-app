//
//  Checklist.swift
//  checklist
//
//  Created by Ibrahim Wassouf on 2022-11-07.
//

import UIKit

class Checklist: NSObject, Codable {
    var name: String = ""
    
    init(name: String){
        self.name = name
        super.init()
    }

}
