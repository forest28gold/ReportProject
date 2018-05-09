//
//  OrganismData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/15/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation

struct OrganismData {

    var name: String
    var email: String
    var phoneNumber: String
    var latitude: Double
    var longitude: Double
    var categoryIds: Array<String>
    
    init(name: String, email: String, phoneNumber: String, latitude: Double, longitude: Double, categoryIds: Array<String>) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.latitude = latitude
        self.longitude = longitude
        self.categoryIds = categoryIds
    }
}
