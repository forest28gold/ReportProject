//
//  OccurData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/24/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation

struct OccurData {
    
    var title: String
    var icon_img: String
    var isSelected: Bool
    
    init(title: String, icon_img: String, isSelected: Bool) {
        self.title = title
        self.icon_img = icon_img
        self.isSelected = isSelected
    }
}
