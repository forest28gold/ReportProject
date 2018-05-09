//
//  MASettingsViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation

class MASettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, ShowsAlert {

    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var settingsTableView: UITableView!
    var settingsArray = [NSLocalizedString("Share the app", comment: ""),
                         NSLocalizedString("Rate the application", comment: ""),
                         NSLocalizedString("Contact us", comment: ""),
                         NSLocalizedString("About", comment: ""),
                         NSLocalizedString("Allow geolocation", comment: "")]
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                navHeight.constant += 25
                self.view.layoutIfNeeded()
                print("iPhone X")
                break
            default:
                print("iPhone")
                break
            }
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func shareApp() {
        let text = NSLocalizedString("Please download malamo app. Here is the link.", comment: "")
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //===================================
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    //===================================
    
    func contactUs() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Call us", comment: ""), style: .default , handler:{ (UIAlertAction) in
            if let url = NSURL(string: "tel://\(Constants.CONTACTUS_PHONE)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Send us an email", comment: ""), style: .default , handler:{ (UIAlertAction) in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([Constants.SUPPORT_EMAIL])
                mail.setSubject(NSLocalizedString("malamo feedback", comment: ""))
                mail.setMessageBody("", isHTML: false)
                
                self.present(mail, animated: true)
            } else {
                // show failure alert
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    //===================================
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath)
        
        let nameLable = cell.viewWithTag(1) as? UILabel
        nameLable?.text = settingsArray[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if indexPath.row == 0 { //Share the app
            shareApp()
        } else if indexPath.row == 1 { //Rate the application
            rateApp(appId: Constants.APP_ID) { success in
                print("RateApp \(success)")
            }
        } else if indexPath.row == 2 { //Contact Us
            contactUs()
        } else if indexPath.row == 3 { //About
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAAboutViewController") as! MAAboutViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else { //Allow geolocation
            locationManager = CLLocationManager()
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
                self.showAlert(message: NSLocalizedString("Already allowed geolocation", comment: ""))
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

}
