//
//  MAStep7ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MAStep7ViewController: UIViewController, UITextFieldDelegate, ShowsAlert {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var identificationButton: UIButton!
    @IBOutlet weak var anonymityButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var identificationView: UIView!
    @IBOutlet weak var contactView: UIView!
    
    @IBOutlet weak var cprmvYesButton: UIButton!
    @IBOutlet weak var cprmvNoButton: UIButton!
    @IBOutlet weak var contactYesButton: UIButton!
    @IBOutlet weak var contactNoButton: UIButton!
    
    var isIdentication = true
    var isCPRMV = true
    var isContact = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                navHeight.constant += 25
                btnLeftMargin.constant += CGFloat(BUTTON_MARGIN)
                btnRightMargin.constant += CGFloat(BUTTON_MARGIN)
                nextButton.layer.cornerRadius = CGFloat(BUTTON_RADIUS)
                self.view.layoutIfNeeded()
                print("iPhone X")
                break
            default:
                print("iPhone")
                break
            }
        }
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: nameTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor("#323F4F")])
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstNameTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor("#323F4F")])
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor("#323F4F")])
        phoneTextField.attributedPlaceholder = NSAttributedString(string: phoneTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor("#323F4F")])
        
        identificationButton.backgroundColor = UIColor("#6a5bd0")
        anonymityButton.backgroundColor = UIColor("#E8EEF4")
        cprmvYesButton.backgroundColor = UIColor("#6a5bd0")
        cprmvNoButton.backgroundColor = UIColor("#E8EEF4")
        contactYesButton.backgroundColor = UIColor("#6a5bd0")
        contactNoButton.backgroundColor = UIColor("#E8EEF4")
        
        isIdentication = true
        isCPRMV = true
        isContact = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func handleTapFrom(recognizer : UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            firstNameTextField.becomeFirstResponder()
        } else if textField == firstNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            dismissKeyboard()
        }
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //===================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func identificationButtonPressed(_ sender: Any) {
        identificationButton.backgroundColor = UIColor("#6a5bd0")
        anonymityButton.backgroundColor = UIColor("#E8EEF4")
        identificationButton.setTitleColor(UIColor.white, for: .normal)
        anonymityButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        
        isIdentication = true
        identificationView.isHidden = false
    }
    
    @IBAction func anonymityButtonPressed(_ sender: Any) {
        identificationButton.backgroundColor = UIColor("#E8EEF4")
        anonymityButton.backgroundColor = UIColor("#6a5bd0")
        identificationButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        anonymityButton.setTitleColor(UIColor.white, for: .normal)
        
        isIdentication = false
        identificationView.isHidden = true
    }
    
    @IBAction func cprmvYesButtonPressed(_ sender: Any) {
        cprmvYesButton.backgroundColor = UIColor("#6a5bd0")
        cprmvNoButton.backgroundColor = UIColor("#E8EEF4")
        cprmvYesButton.setTitleColor(UIColor.white, for: .normal)
        cprmvNoButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        
        isCPRMV = true
        contactView.isHidden = false
    }
    
    @IBAction func cprmvNoButtonPressed(_ sender: Any) {
        cprmvYesButton.backgroundColor = UIColor("#E8EEF4")
        cprmvNoButton.backgroundColor = UIColor("#6a5bd0")
        cprmvYesButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        cprmvNoButton.setTitleColor(UIColor.white, for: .normal)
        
        isCPRMV = false
        contactView.isHidden = true
    }
    
    @IBAction func contactYesButtonPressed(_ sender: Any) {
        contactYesButton.backgroundColor = UIColor("#6a5bd0")
        contactNoButton.backgroundColor = UIColor("#E8EEF4")
        contactYesButton.setTitleColor(UIColor.white, for: .normal)
        contactNoButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        
        isContact = true
    }
    
    @IBAction func contactNoButtonPressed(_ sender: Any) {
        contactYesButton.backgroundColor = UIColor("#E8EEF4")
        contactNoButton.backgroundColor = UIColor("#6a5bd0")
        contactYesButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        contactNoButton.setTitleColor(UIColor.white, for: .normal)
        
        isContact = false
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {

        if isIdentication {
            
            if nameTextField.text == "" {
                self.showAlert(message: NSLocalizedString("Please input last name.", comment: ""))
                return
            } else if firstNameTextField.text == "" {
                self.showAlert(message: NSLocalizedString("Please input first name.", comment: ""))
                return
            } else if emailTextField.text == "" {
                self.showAlert(message: NSLocalizedString("Please input email.", comment: ""))
                return
            } else if !GlobalData.validateEmail(enteredEmail: emailTextField.text!) {
                self.showAlert(message: NSLocalizedString("Email format is invalid.", comment: ""))
                return
            } else if phoneTextField.text == "" {
                self.showAlert(message: NSLocalizedString("Please input phone number.", comment: ""))
                return
            }
            
            GlobalData.incidentReport?.isAnonym = false
            
            GlobalData.incidentReport?.userLastName = nameTextField.text!
            GlobalData.incidentReport?.userFirstName = firstNameTextField.text!
            GlobalData.incidentReport?.userEmail = emailTextField.text!
            GlobalData.incidentReport?.userPhone = phoneTextField.text!
            
        } else {
            GlobalData.incidentReport?.isAnonym = true
            
            GlobalData.incidentReport?.userLastName = ""
            GlobalData.incidentReport?.userFirstName = ""
            GlobalData.incidentReport?.userEmail = ""
            GlobalData.incidentReport?.userPhone = ""
            
            isCPRMV = false
            isContact = false
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Are you sure you want to submit your report?", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Submit", comment: ""), style: UIAlertActionStyle.default, handler: { action in
            self.submitReportData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func submitReportData() {
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
        
        let myReport = PFObject(className: Constants.CLASS_REPORT)
        
        myReport["trackingNumber"] = GlobalData.incidentReport?.trackingNumber
        myReport["relatedNumber"] = GlobalData.relatedReportNumber
        myReport["reportStatus"] = NSLocalizedString("Reported", comment: "")
        myReport["reportType"] = GlobalData.incidentReport?.reportType
        myReport["incidentKindIds"] = GlobalData.incidentKindIds
        myReport["incidentReasonIds"] = GlobalData.incidentReasonIds
        myReport["incidentDescription"] = GlobalData.incidentReport?.incidentDescripion
        myReport["incidentOccurType"] = GlobalData.incidentReport?.incidentOccurType
        
        if GlobalData.incidentReport?.incidentOccurType == NSLocalizedString("Physical location or address", comment: "") {
            myReport["incidentDate"] = GlobalData.incidentReport?.incidentDate
            myReport["incidentTime"] = GlobalData.incidentReport?.incidentTime
            myReport["incidentAddressDesc"] = GlobalData.incidentReport?.incidentAddressDesc
            myReport["incidentAddress"] = GlobalData.incidentAddress
            myReport["incidentCoordinate"] = PFGeoPoint(latitude:GlobalData.incidentLatitude, longitude:GlobalData.incidentLongitude)
            myReport["city"] = ""
            myReport["transportMode"] = ""
            myReport["serviceNumber"] = ""
            myReport["onlinePlatform"] = ""
            myReport["url"] = ""
        } else if GlobalData.incidentReport?.incidentOccurType == NSLocalizedString("This happened in transportation", comment: "") {
            myReport["incidentDate"] = GlobalData.incidentReport?.incidentDate
            myReport["incidentTime"] = GlobalData.incidentReport?.incidentTime
            myReport["incidentAddressDesc"] = ""
            myReport["incidentAddress"] = ""
//            myReport["incidentCoordinate"] = PFGeoPoint(latitude:GlobalData.incidentLatitude, longitude:GlobalData.incidentLongitude)
            myReport["city"] = GlobalData.incidentReport?.city
            myReport["transportMode"] = GlobalData.incidentReport?.transportMode
            myReport["serviceNumber"] = GlobalData.incidentReport?.serviceNumber
            myReport["onlinePlatform"] = ""
            myReport["url"] = ""
        } else if GlobalData.incidentReport?.incidentOccurType == NSLocalizedString("This happened on the internet / social media", comment: "") {
            myReport["incidentDate"] = GlobalData.incidentReport?.incidentDate
            myReport["incidentTime"] = GlobalData.incidentReport?.incidentTime
            myReport["incidentAddressDesc"] = ""
            myReport["incidentAddress"] = ""
            myReport["city"] = ""
            myReport["transportMode"] = ""
            myReport["serviceNumber"] = ""
            myReport["onlinePlatform"] = GlobalData.incidentReport?.onlinePlatform
            myReport["url"] = GlobalData.incidentReport?.url
        } else {
            myReport["incidentDate"] = ""
            myReport["incidentTime"] = ""
            myReport["incidentAddressDesc"] = ""
            myReport["incidentAddress"] = ""
            myReport["city"] = ""
            myReport["transportMode"] = ""
            myReport["serviceNumber"] = ""
            myReport["onlinePlatform"] = ""
            myReport["url"] = ""
        }
        
        myReport["peopleNumber"] = GlobalData.incidentReport?.peopleNumber
        myReport["hasAggressor"] = GlobalData.incidentReport?.hasAggressor
        myReport["isVictim"] = GlobalData.incidentReport?.isVictim
        myReport["hasVictim"] = GlobalData.incidentReport?.hasVictim
        myReport["isAnonym"] = GlobalData.incidentReport?.isAnonym
        myReport["userLastName"] = GlobalData.incidentReport?.userLastName
        myReport["userFirstName"] = GlobalData.incidentReport?.userFirstName
        myReport["userEmail"] = GlobalData.incidentReport?.userEmail
        myReport["userPhone"] = GlobalData.incidentReport?.userPhone
        myReport["allowCPRMV"] = isCPRMV
        myReport["allowContact"] = isContact
        
        myReport.saveInBackground { (success, error) in
            if (success) {
                // The object has been saved.

                for mediaData in GlobalData.linkArray {
                    let media = PFObject(className: Constants.CLASS_MEDIA)
                    media["type"] = "weblink"
                    media["weblink"] = mediaData
                    media["report"] = PFObject(withoutDataWithClassName:Constants.CLASS_REPORT, objectId:myReport.objectId)
                    media.saveInBackground(block: { (success, error) in
                        if success {
                            let relation = myReport.relation(forKey: "media")
                            relation.add(media)
                            myReport.saveInBackground()
                        }
                    })
                }
                
                for aggressorData in GlobalData.aggressorArray {
                    let aggressor = PFObject(className: Constants.CLASS_AGGRESSOR)
                    aggressor["lastname"] = aggressorData.name
                    aggressor["firstname"] = aggressorData.firstName
                    aggressor["gender"] = aggressorData.gender
                    aggressor["ageRange"] = aggressorData.age
                    aggressor["ethnic"] = aggressorData.ethnic
                    aggressor["specialSign"] = aggressorData.signs
                    aggressor["report"] = PFObject(withoutDataWithClassName:Constants.CLASS_REPORT, objectId:myReport.objectId)
                    aggressor.saveInBackground(block: { (success, error) in
                        if success {
                            let relation = myReport.relation(forKey: "aggressor")
                            relation.add(aggressor)
                            myReport.saveInBackground()
                        }
                    })
                }
                
                for victimData in GlobalData.victimArray {
                    let victim = PFObject(className: Constants.CLASS_VICTIM)
                    victim["isKnown"] = victimData.known
                    victim["victimRelationship"] = victimData.relation
                    victim["gender"] = victimData.gender
                    victim["ageRange"] = victimData.age
                    victim["ethnic"] = victimData.ethnic
                    victim["sexualOrientation"] = victimData.sexual
                    victim["religion"] = victimData.religion
                    victim["motherTongue"] = victimData.language
                    victim["handicap"] = victimData.consider
                    victim["otherInformation"] = victimData.others
                    victim["report"] = PFObject(withoutDataWithClassName:Constants.CLASS_REPORT, objectId:myReport.objectId)
                    victim.saveInBackground(block: { (success, error) in
                        if success {
                            let relation = myReport.relation(forKey: "victim")
                            relation.add(victim)
                            myReport.saveInBackground()
                        }
                    })
                }
                
                if GlobalData.mediaArray.count > 0 {
                    
                    DispatchQueue.main.async { () -> Void in
                     
                        var mediaCount: Int = 1
                        
                        for mediaData in GlobalData.mediaArray {
                            let media = PFObject(className: Constants.CLASS_MEDIA)
                            media["type"] = mediaData.type
                            media["report"] = PFObject(withoutDataWithClassName:Constants.CLASS_REPORT, objectId:myReport.objectId)
                            if mediaData.type == "photo" {
                                let random = GlobalData.randomNumber(length: Constants.RECORD_NUMBER_LIMIT)
                                let fileName = random + ".png"
                                let imageData = UIImagePNGRepresentation(mediaData.photo)
                                let imageFile = PFFile(name:fileName, data:imageData!)
                                imageFile?.saveInBackground(block: { (success, error) in
                                    if success {
                                        media["file"] = imageFile
                                        media.saveInBackground(block: { (success, error) in
                                            if success {
                                                let relation = myReport.relation(forKey: "media")
                                                relation.add(media)
                                                myReport.saveInBackground()
                                            }
                                        })
                                    }
                                })
                            } else if mediaData.type == "video" {
                                var videoData: Data?
                                let random = GlobalData.randomNumber(length: Constants.RECORD_NUMBER_LIMIT)
                                let fileName = random + ".mp4"
                                videoData = try? Data(contentsOf: URL(fileURLWithPath: mediaData.path))
                                let videoFile = PFFile(name: fileName, data: videoData!)
                                videoFile?.saveInBackground(block: { (success, error) in
                                    if success {
                                        media["file"] = videoFile
                                        media.saveInBackground(block: { (success, error) in
                                            if success {
                                                let relation = myReport.relation(forKey: "media")
                                                relation.add(media)
                                                myReport.saveInBackground()
                                            }
                                        })
                                    }
                                })
                            } else if mediaData.type == "audio" {
                                var soundData: Data?
                                if  FileManager.default.fileExists(atPath: mediaData.path) {
                                    let random = GlobalData.randomNumber(length: Constants.RECORD_NUMBER_LIMIT)
                                    let fileName = random + ".mp4"
                                    soundData = try? Data(contentsOf: URL(fileURLWithPath: mediaData.path))
                                    let soundFile = PFFile(name: fileName, data: soundData!)
                                    soundFile?.saveInBackground(block: { (success, error) in
                                        if success {
                                            self.removeRecordFile(mediaData.path)
                                            
                                            media["file"] = soundFile
                                            media.saveInBackground(block: { (success, error) in
                                                if success {
                                                    let relation = myReport.relation(forKey: "media")
                                                    relation.add(media)
                                                    myReport.saveInBackground()
                                                }
                                            })
                                        }
                                    })
                                }
                            }
                            
                            if mediaCount == GlobalData.mediaArray.count {
                                SVProgressHUD.dismiss()
                                self.moveNextStep()
                            } else {
                                mediaCount = mediaCount + 1
                            }
                        }
                    }
                    
                } else {
                    SVProgressHUD.dismiss()
                    self.moveNextStep()
                }
                
            } else {
                self.showAlert(message: NSLocalizedString("Report submission is failed. Please try again.", comment: ""))
                return
            }
        }
    }
    
    func moveNextStep() {
        
//        DispatchQueue.main.async { () -> Void in
//
//            //Email Sending...
//            let param = GlobalData.incidentReport?.trackingNumber
//            PFCloud.callFunction(inBackground: "sendTrackingNumber", withParameters: ["trackingNumber" : param as Any], block: { (respond, error) in
//                if error == nil {
//                    print("Send email successfully")
//                } else {
//                    print("Send email is failed")
//                }
//            })
//        }
    
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep8ViewController") as! MAStep8ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //============================
    
    func removeRecordFile(_ filePath: String) {
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: filePath) {
                try fileManager.removeItem(atPath: filePath)
                print("Successfully removed")
            } else {
                print("File does not exist")
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}
