//
//  MAHomeViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MAHomeViewController: UIViewController, ShowsAlert {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let pre = Locale.preferredLanguages[0]
        if pre.range(of:"fr") != nil {
            GlobalData.currentLocale = Constants.LOCALE_FR
        } else {
            GlobalData.currentLocale = Constants.LOCALE_EN
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !GlobalData.isWelcome {
            GlobalData.isWelcome = true
            showWelcomeToMalamo()
        }
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
    
    func showWelcomeToMalamo() {
        
        let alert = UIAlertController(title: NSLocalizedString("Welcome to MALAMO", comment: ""), message: NSLocalizedString("If your safety or that of another person is threatened, If you need emergency help, Dial 911 immediately", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Call 911", comment: ""), style: UIAlertActionStyle.destructive, handler: { action in
            //call 911
            if let url = NSURL(string: "tel://\(911)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //===================================
    
    func showTrackingNumberAlert() {
        
        let alertController = UIAlertController(title: NSLocalizedString("Tracking number", comment: ""), message: NSLocalizedString("If you have already submitted a report in MALAMO, enter your tracking number to know the status of your report.", comment: ""), preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: ""), style: .default, handler: {
            alert -> Void in
            
            let trackingNumberTextField = alertController.textFields![0] as UITextField
            if trackingNumberTextField.text != "" {
                self.showStatusOfReport(trackingNumberTextField.text!.uppercased())
            } else {
                // Show Alert Message to User As per you want

                let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please input tracking number", comment: ""), preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
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
    
    func showStatusOfReport(_ strTrackingNumber:String) {
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
        
        let query = PFQuery(className: Constants.CLASS_REPORT)
        query.whereKey("trackingNumber", equalTo:strTrackingNumber)
        query.findObjectsInBackground (block: { (objects, error) in

            SVProgressHUD.dismiss()

            if error == nil {
                if objects!.count > 0 {
                    if let objects = objects {
                        let status = GlobalData.onCheckStringNull(object: objects[0], key: "reportStatus")

                        let strTitle = NSLocalizedString("Status of the report \n ", comment: "") + strTrackingNumber + ":"
                        let alert = UIAlertController(title: strTitle, message: status, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.showAlert(message: NSLocalizedString("Tracking number is invalid.", comment: ""))
                    }
                } else {
                    self.showAlert(message: NSLocalizedString("Tracking number is invalid.", comment: ""))
                }
            } else {
                self.showAlert(message: NSLocalizedString("Tracking number is invalid.", comment: ""))
            }
        })
    }
    
    //===================================
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAReportingViewController") as! MAReportingViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func trackingNumberButtonPressed(_ sender: Any) {
        showTrackingNumberAlert()
    }
    
    @IBAction func resourceButtonPressed(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAResourcesViewController") as! MAResourcesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MASettingsViewController") as! MASettingsViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func cprmvButtonPressed(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAWebViewController") as! MAWebViewController
        nextViewController.strTitle = NSLocalizedString("CPRMV", comment: "")
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            nextViewController.strLink = Constants.CPRMV_URL_FR
        } else {
            nextViewController.strLink = Constants.CPRMV_URL_EN
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func faqButtonPressed(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAFAQViewController") as! MAFAQViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func learnMoreButtonPressed(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MALearnMoreViewController") as! MALearnMoreViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
