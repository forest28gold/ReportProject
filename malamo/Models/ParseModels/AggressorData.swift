//
//  AggressorData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/15/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation

struct AggressorData {
    
    var name: String
    var firstName: String
    var gender: String
    var age: String
    var ethnic: String
    var signs: String
    
    init(name: String, firstName: String, gender: String, age: String, ethnic: String, signs: String) {
        self.name = name
        self.firstName = firstName
        self.gender = gender
        self.age = age
        self.ethnic = ethnic
        self.signs = signs
    }
}
