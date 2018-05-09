//
//  MAReportingViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import UIColor_Hex_Swift
import SVProgressHUD

class MAReportingViewController: UIViewController, ShowsAlert {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    
    @IBOutlet weak var witnessButton: UIButton!
    @IBOutlet weak var victimButton: UIButton!
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var isWitness = false
    var isStart = false

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
        
        nextButton.isHidden = true
        
        witnessButton.backgroundColor = UIColor("#20252b")
        victimButton.backgroundColor = UIColor("#20252b")
        isWitness = false
        isStart = false
        
        GlobalData.incidentReport = ReportData.init(trackingNumber: "", reportStatus: "", reportType: "", incidentDescripion: "", incidentOccurType: "", incidentDate: "", incidentTime: "", incidentAddressDesc: "", incidentAddress: "", city: "", transportMode: "", serviceNumber: "", onlinePlatform: "", url: "", peopleNumber: "", hasAggressor: false, isVictim: false, hasVictim: false, isAnonym: false, userLastName: "", userFirstName: "", userEmail: "", userPhone: "")
        
        GlobalData.mediaArray = [MediaData]()
        GlobalData.linkArray = [String]()
        GlobalData.aggressorArray = [AggressorData]()
        GlobalData.victimArray = [VictimData]()
        GlobalData.relatedReportNumber = ""
        
        let strTrackingNumber = GlobalData.randomString(length: Constants.TRACKING_NUMBER_LIMIT)
        GlobalData.incidentReport?.trackingNumber = strTrackingNumber
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
    
    func showTrackingNumberAlert() {
        
        let alertController = UIAlertController(title: NSLocalizedString("Tracking number", comment: ""), message: NSLocalizedString("Please enter your tracking number.", comment: ""), preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: ""), style: .default, handler: {
            alert -> Void in
            
            let trackingNumberTextField = alertController.textFields![0] as UITextField
            if trackingNumberTextField.text == "" {
                
                let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please input tracking number", comment: ""), preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
                
            } else if (trackingNumberTextField.text?.count)! < 7 {
                
                let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please input tracking number more than 7 characters.", comment: ""), preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
                
            } else {
                self.showStatusOfReport(trackingNumberTextField.text!)
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        // add the textField
        alertController.addTextField { (textField : UITextField!) -> Void in
            //textField.placeholder = "Tracking Number"
            textField.textAlignment = .center
            textField.font = UIFont.boldSystemFont(ofSize: 18)
            textField.returnKeyType = UIReturnKeyType.done
            textField.autocapitalizationType = .allCharacters
        }
        // add the actions (buttons)
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        // show the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showStatusOfReport(_ strNumber:String) {
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
        
        let query = PFQuery(className: Constants.CLASS_REPORT)
        query.whereKey("trackingNumber", equalTo:strNumber)
        query.findObjectsInBackground (block: { (objects, error) in
            
            SVProgressHUD.dismiss()
            
            if error == nil {
                if objects!.count > 0 {
                    self.numberButton.setTitle(NSLocalizedString("Tracking number", comment: "") + " :   " + strNumber, for: .normal)
                    GlobalData.relatedReportNumber = strNumber;
                } else {
                    self.showAlert(message: NSLocalizedString("Tracking number is invalid", comment: ""))
                }
            } else {
                self.showAlert(message: NSLocalizedString("Tracking number is invalid", comment: ""))
            }
        })
    }
    
    //===================================
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func witnessButtonPressed(_ sender: Any) {
        isWitness = true
        isStart = true
        witnessButton.backgroundColor = UIColor("#6a5bd0")
        victimButton.backgroundColor = UIColor("#20252b")
        
        GlobalData.incidentReport?.reportType = NSLocalizedString("Witness", comment: "")
        onNextMove()
    }
    
    @IBAction func victimButtonPressed(_ sender: Any) {
        isWitness = false
        isStart = true
        witnessButton.backgroundColor = UIColor("#20252b")
        victimButton.backgroundColor = UIColor("#6a5bd0")
        
        GlobalData.incidentReport?.reportType = NSLocalizedString("Victim", comment: "")
        onNextMove()
    }
    
    @IBAction func trackingNumberButtonPressed(_ sender: Any) {
        showTrackingNumberAlert()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if !isStart {
            self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
            return
        }
        
        if isWitness {
            GlobalData.incidentReport?.reportType = NSLocalizedString("Witness", comment: "")
        } else {
            GlobalData.incidentReport?.reportType = NSLocalizedString("Victim", comment: "")
        }
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep1ViewController") as! MAStep1ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func onNextMove() {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep1ViewController") as! MAStep1ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
