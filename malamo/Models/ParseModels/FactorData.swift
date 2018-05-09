//
//  FactorData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/14/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation

struct FactorData {
    
    var objectId: String
    var name: String
    var info_title: String
    var info: String
    var example: String
    var legal: String
    var name_fr: String
    var info_title_fr: String
    var info_fr: String
    var example_fr: String
    var legal_fr: String
    var icon_img: String
    var icon_info_img: String
    var isSelected: Bool
    
    init(objectId: String, name: String, info: String, info_title: String, example: String, legal: String,
         name_fr: String, info_title_fr: String, info_fr: String, example_fr: String, legal_fr: String,
         icon_img: String, icon_info_img: String, isSelected: Bool) {
        
        self.objectId = objectId
        self.name = name
        self.info_title = info_title
        self.info = info
        self.example = example
        self.legal = legal
        self.name_fr = name_fr
        self.info_title_fr = info_title_fr
        self.info_fr = info_fr
        self.example_fr = example_fr
        self.legal_fr = legal_fr
        self.icon_img = icon_img
        self.icon_info_img = icon_info_img
        self.isSelected = isSelected
    }
}
