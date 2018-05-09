//
//  GlobalData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/14/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
import UIKit
import Parse

protocol ShowsAlert {}

extension ShowsAlert where Self: UIViewController {
    func showAlert(title: String = NSLocalizedString("Alert", comment: ""), message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

class GlobalData {
    
    static let sharedInstance = GlobalData()
    private init() {
        print("GlobalDataClass Initialized")
    }
    
    static var currentLocale = "en"
    static var faqArray = [FAQData]()
    static var knowMoreArray = [KnowMoreData]()
    static var categoryArray = [FactorData]()
    static var factorArray = [FactorData]()
    static var filterArray = [FactorData]()
    static var transportModeArray = [PickerData]()
    static var onlinePlatformArray = [PickerData]()
    static var ethnicArray = [String]()
    static var religionArray = [String]()
    static var motherTongueArray = [String]()
    static var relationshipArray = [PickerData]()
    
    static var isWelcome = false
    static var incidentReport: ReportData?
    static var relatedReportNumber = ""
    static var incidentKindIds = [String]()
    static var incidentReasonIds = [String]()
    static var isDescrition = true
    static var incidentDescription = ""
    static var locationDetails = ""
    static var isRecord = false
    static var audioFilePath = ""
    static var mediaArray = [MediaData]()
    static var linkArray = [String]()
    static var aggressorArray = [AggressorData]()
    static var victimArray = [VictimData]()
    
    static var organismArray = [OrganismData]()
    static var organismIdsArray = [String]()
    static var isSeeAll = true
    
    static var isCity = false
    static var isLocation = false
    static var incidentLatitude = 0.0
    static var incidentLongitude = 0.0
    static var incidentAddress = ""
    
    
    static public func onCheckStringNull(object: PFObject, key: String) -> String {
        let value = object[key] as? String
        if value == nil {
            return ""
        } else {
            return value!
        }
    }
    
    static public func onCheckFileNull(object: PFObject, key: String) -> String {
        let value = object[key] as? PFFile
        if value == nil {
            return ""
        } else {
            return (value?.url)!
        }
    }
    
    static public func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    static public func randomString(length: Int) -> String {
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    static public func randomNumber(length: Int) -> String {
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}
