//
//  MAStep8ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit

class MAStep8ViewController: UIViewController {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var trackingNumberLabel: UILabel!

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

        trackingNumberLabel.attributedText = NSAttributedString(string: (GlobalData.incidentReport?.trackingNumber)!, attributes:[ NSAttributedStringKey.kern: 10])
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
    
    func saveTrackingNumber() {
        let text = NSLocalizedString("Tracking number", comment: "") + " :   " + (GlobalData.incidentReport?.trackingNumber)!
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveTrackingNumber()
    }
    
    @IBAction func browserButtonPressed(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAResourcesViewController") as! MAResourcesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func contactMontrealButtonPressed(_ sender: Any) {
        let phoneNumber = "5146877141"
        if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func contactQuebecButtonPressed(_ sender: Any) {
        let phoneNumber = "18776877141"
        if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let root = storyboard?.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
        let home = storyboard?.instantiateViewController(withIdentifier: "MAHomeViewController")
        root.setViewControllers([home!], animated: true)
        UIApplication.shared.keyWindow?.rootViewController = root
    }

}
