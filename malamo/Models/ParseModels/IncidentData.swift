//
//  IncidentData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/15/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
import Parse

struct IncidentData {
    
    var trackingNumber: String
    var reportStatus: String
    var reportType: String
    var incidentKindIds: Array<String>
    var incidentReasonIds: Array<String>
    var incidentDescripion: String
    var media: PFRelation<PFObject>
    var incidentOccurType: String
    var incidentDate: String
    var incidentTime: String
    var incidentCoordinate: PFGeoPoint
    var incidentAddressDesc: String
    var incidentAddress: String
    var city: String
    var transportMode: String
    var serviceNumber: String
    var onlinePlatform: String
    var url: String
    var peopleNumber: Int
    var hasAggressor: Bool
    var aggressor: PFRelation<PFObject>
    var isVictim: Bool
    var hasVictim: Bool
    var victim: PFRelation<PFObject>
    var isAnonym: Bool
    var userLastName: String
    var userFirstName: String
    var userEmail: String
    var userPhone: String
    
    init(trackingNumber: String, reportStatus: String, reportType: String,
         incidentKindIds: Array<String>, incidentReasonIds: Array<String>,
         incidentDescripion: String, media: PFRelation<PFObject>,
         incidentOccurType: String, incidentDate: String, incidentTime: String,
         incidentCoordinate: PFGeoPoint,
         incidentAddressDesc: String, incidentAddress: String,
         city: String, transportMode: String, serviceNumber: String,
         onlinePlatform: String, url: String,
         peopleNumber: Int, hasAggressor: Bool, aggressor: PFRelation<PFObject>,
         isVictim: Bool, hasVictim: Bool, victim: PFRelation<PFObject>,
         isAnonym: Bool, userLastName: String, userFirstName: String, userEmail: String, userPhone: String) {
        
        self.trackingNumber = trackingNumber
        self.reportStatus = reportStatus
        self.reportType = reportType
        self.incidentKindIds = incidentKindIds
        self.incidentReasonIds = incidentReasonIds
        self.incidentDescripion = incidentDescripion
        self.media = media
        self.incidentOccurType = incidentOccurType
        self.incidentDate = incidentDate
        self.incidentTime = incidentTime
        self.incidentCoordinate = incidentCoordinate
        self.incidentAddressDesc = incidentAddressDesc
        self.incidentAddress = incidentAddress
        self.city = city
        self.transportMode = transportMode
        self.serviceNumber = serviceNumber
        self.onlinePlatform = onlinePlatform
        self.url = url
        self.peopleNumber = peopleNumber
        self.hasAggressor = hasAggressor
        self.aggressor = aggressor
        self.isVictim = isVictim
        self.hasVictim = hasVictim
        self.victim = victim
        self.isAnonym = isAnonym
        self.userLastName = userLastName
        self.userFirstName = userFirstName
        self.userEmail = userEmail
        self.userPhone = userPhone
    }
}
