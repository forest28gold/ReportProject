//
//  MADetailsViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/14/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit

class MADetailsViewController: UIViewController, UITextViewDelegate, ShowsAlert {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var okButton: UIButton!

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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: .UIKeyboardDidHide, object: nil)
        
        if GlobalData.isDescrition {
            titleLabel.text = NSLocalizedString("Description of the incident", comment: "")
            if GlobalData.incidentDescription == "" {
                okButton.isEnabled = false
                descriptionTextView.text = NSLocalizedString("Describe the general course of the incident. More specific information about the location, date and time, the victim(s), and the perpetrator(s) related to the incident may be specified in later stages of the reporting process.", comment: "")
                descriptionTextView.textColor = UIColor("#7c90a6")
            } else {
                okButton.isEnabled = true
                descriptionTextView.text = GlobalData.incidentDescription
                descriptionTextView.textColor = UIColor("#4a5664")
            }
        } else {
            titleLabel.text = NSLocalizedString("Location Details", comment: "")
            if GlobalData.locationDetails == "" {
                okButton.isEnabled = false
                descriptionTextView.text = NSLocalizedString("Describe the location details.", comment: "")
                descriptionTextView.textColor = UIColor("#7c90a6")
            } else {
                okButton.isEnabled = true
                descriptionTextView.text = GlobalData.locationDetails
                descriptionTextView.textColor = UIColor("#4a5664")
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
    
    @objc func handleTapFrom(recognizer : UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @objc func keyBoardDidShow(notification: NSNotification) {
        //handle appearing of keyboard here
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            var frame = self.descriptionTextView.frame
            frame.size.height = self.view.frame.size.height - keyboardHeight - 64 - 85
            self.descriptionTextView.frame = frame
        }
    }
    
    @objc func keyBoardDidHide(notification: NSNotification) {
        //handle dismiss of keyboard here
        
        var frame = self.descriptionTextView.frame
        frame.size.height = self.view.frame.size.height - 64 - 35
        self.descriptionTextView.frame = frame
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if GlobalData.isDescrition {
            if descriptionTextView.text == NSLocalizedString("Describe the general course of the incident. More specific information about the location, date and time, the victim(s), and the perpetrator(s) related to the incident may be specified in later stages of the reporting process.", comment: "") {
                descriptionTextView.text = ""
            }
        } else {
            if descriptionTextView.text == NSLocalizedString("Describe the location details.", comment: "") {
                descriptionTextView.text = ""
            }
        }
        descriptionTextView.textColor = UIColor("#4a5664")
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if changedText.count > 0 {
            okButton.isEnabled = true
        } else {
            okButton.isEnabled = false
        }
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            okButton.isEnabled = false
            if GlobalData.isDescrition {
                descriptionTextView.text = NSLocalizedString("Describe the general course of the incident. More specific information about the location, date and time, the victim(s), and the perpetrator(s) related to the incident may be specified in later stages of the reporting process.", comment: "")
            } else {
                descriptionTextView.text = NSLocalizedString("Describe the location details.", comment: "")
            }
            descriptionTextView.textColor = UIColor("#7c90a6")
        }
    }
    
    //==================================
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if GlobalData.isDescrition {
//            if descriptionTextView.text.count < 1000 {
//                self.showAlert(message: NSLocalizedString("A minimum of 1000 characters is required for this description.", comment: ""))
//                return
//            }
            GlobalData.incidentDescription = descriptionTextView.text
        } else {
            GlobalData.locationDetails = descriptionTextView.text
        }
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }

}
