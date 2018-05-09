//
//  VictimData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/15/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation

struct VictimData {
    
    var known: String
    var relation: String
    var gender: String
    var age: String
    var ethnic: String
    var sexual: String
    var religion: String
    var language: String
    var consider: String
    var others: String
    
    init(known: String, relation: String, gender: String, age: String, ethnic: String, sexual: String, religion: String, language: String, consider: String, others: String) {
        self.known = known
        self.relation = relation
        self.gender = gender
        self.age = age
        self.ethnic = ethnic
        self.sexual = sexual
        self.religion = religion
        self.language = language
        self.consider = consider
        self.others = others
    }
}
