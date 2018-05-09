//
//  ReportData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/15/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
import Parse

struct ReportData {
    
    var trackingNumber: String
    var reportStatus: String
    var reportType: String
    var incidentDescripion: String
    var incidentOccurType: String
    var incidentDate: String
    var incidentTime: String
    var incidentAddressDesc: String
    var incidentAddress: String
    var city: String
    var transportMode: String
    var serviceNumber: String
    var onlinePlatform: String
    var url: String
    var peopleNumber: String
    var hasAggressor: Bool
    var isVictim: Bool
    var hasVictim: Bool
    var isAnonym: Bool
    var userLastName: String
    var userFirstName: String
    var userEmail: String
    var userPhone: String
    
    init(trackingNumber: String, reportStatus: String, reportType: String,
         incidentDescripion: String,
         incidentOccurType: String, incidentDate: String, incidentTime: String,
         incidentAddressDesc: String, incidentAddress: String,
         city: String, transportMode: String, serviceNumber: String,
         onlinePlatform: String, url: String,
         peopleNumber: String, hasAggressor: Bool,
         isVictim: Bool, hasVictim: Bool,
         isAnonym: Bool, userLastName: String, userFirstName: String, userEmail: String, userPhone: String) {
        
        self.trackingNumber = trackingNumber
        self.reportStatus = reportStatus
        self.reportType = reportType
        self.incidentDescripion = incidentDescripion
        self.incidentOccurType = incidentOccurType
        self.incidentDate = incidentDate
        self.incidentTime = incidentTime
        self.incidentAddressDesc = incidentAddressDesc
        self.incidentAddress = incidentAddress
        self.city = city
        self.transportMode = transportMode
        self.serviceNumber = serviceNumber
        self.onlinePlatform = onlinePlatform
        self.url = url
        self.peopleNumber = peopleNumber
        self.hasAggressor = hasAggressor
        self.isVictim = isVictim
        self.hasVictim = hasVictim
        self.isAnonym = isAnonym
        self.userLastName = userLastName
        self.userFirstName = userFirstName
        self.userEmail = userEmail
        self.userPhone = userPhone
    }
}
