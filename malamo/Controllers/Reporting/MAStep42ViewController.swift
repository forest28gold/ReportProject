//
//  MAStep42ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MAStep42ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ShowsAlert {
   
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var transportLabel: UILabel!
    @IBOutlet var serviceTextField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var dateView: UIView!
    @IBOutlet var datePickerView: UIDatePicker!
    @IBOutlet var pickerView: UIPickerView!

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
        
        dateView.isHidden = true
        datePickerView.datePickerMode = .date
        let date = NSDate()
        datePickerView.maximumDate = date as Date
        
        initLoadTransportModeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalData.isLocation {
            GlobalData.isLocation = false
            
            cityLabel.text = GlobalData.incidentAddress
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
    
    func initLoadTransportModeData() {
        
        if GlobalData.transportModeArray.count > 0 {
            
        } else {
            let query = PFQuery(className: Constants.CLASS_TRANSPORT_MODE)
            query.order(byAscending: "order")
            query.findObjectsInBackground (block: { (objects, error) in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            let pickerData = PickerData.init(name: name, name_fr: name_fr)
                            GlobalData.transportModeArray.append(pickerData)
                        }
                        self.pickerView.reloadAllComponents()
                    }
                }
            })
        }
    }
    
    //==============================
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        closeAnimationView(dateView)
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        closeAnimationView(dateView)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //=====================================
    
    func showAnimationView(_ mView: UIView) {
        mView.isHidden = false
        mView.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            mView.alpha = 1
            mView.frame = CGRect(x: mView.frame.origin.x, y: self.view.frame.size.height - mView.frame.size.height, width: mView.frame.size.width, height: mView.frame.size.height)
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                
            }
        })
    }
    
    func closeAnimationView(_ mView: UIView) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            mView.alpha = 0
            mView.frame = CGRect(x: mView.frame.origin.x, y: self.view.frame.size.height, width: mView.frame.size.width, height: mView.frame.size.height)
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                mView.isHidden = true
            }
        })
    }
    
    //====================================
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalData.transportModeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            return GlobalData.transportModeArray[row].name_fr
        } else {
            return GlobalData.transportModeArray[row].name
        }
    }
    
    @IBAction func cancelPickerAction(_ sender: Any) {
        closeAnimationView(dateView)
    }
    
    @IBAction func donePickerAction(_ sender: Any) {
        closeAnimationView(dateView)
        
        if pickerView.isHidden == true {
            if datePickerView.datePickerMode == .date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                dateLabel.text = formatter.string(from: datePickerView.date)
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                timeLabel.text = formatter.string(from: datePickerView.date)
            }
        } else {
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                transportLabel.text = GlobalData.transportModeArray[pickerView.selectedRow(inComponent: 0)].name_fr
            } else {
                transportLabel.text = GlobalData.transportModeArray[pickerView.selectedRow(inComponent: 0)].name
            }
        }
    }
    
    //===================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cityButtonPressed(_ sender: Any) {
        dismissKeyboard()
        closeAnimationView(dateView)
        GlobalData.isLocation = false
        GlobalData.isCity = true
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAMapViewController") as! MAMapViewController
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func transportDetailsButtonPressed(_ sender: Any) {
        dismissKeyboard()
        datePickerView.isHidden = true
        
        if GlobalData.transportModeArray.count > 0 {
            pickerView.isHidden = false
            showAnimationView(dateView)
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_TRANSPORT_MODE)
            query.order(byAscending: "order")
            query.findObjectsInBackground (block: { (objects, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            let pickerData = PickerData.init(name: name, name_fr: name_fr)
                            GlobalData.transportModeArray.append(pickerData)
                        }
                        self.pickerView.reloadAllComponents()
                        self.pickerView.isHidden = false
                        self.showAnimationView(self.dateView)
                    }
                }
            })
        }
    }
    
    @IBAction func dateButtonPressed(_ sender: Any) {
        dismissKeyboard()
        datePickerView.isHidden = false
        pickerView.isHidden = true
        datePickerView.datePickerMode = .date
        showAnimationView(dateView)
    }
    
    @IBAction func timeButtonPressed(_ sender: Any) {
        dismissKeyboard()
        datePickerView.isHidden = false
        pickerView.isHidden = true
        datePickerView.datePickerMode = .time
        showAnimationView(dateView)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let incidentDate = formatter.date(from: dateLabel.text!)
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "dd/MM/yyyy HH:mm"
        let incidentTime = formatterTime.date(from: dateLabel.text! + " " + timeLabel.text!)
        
        if cityLabel.text == NSLocalizedString("Ex : city or region", comment: "") {
            self.showAlert(message: NSLocalizedString("Please input city or region.", comment: ""))
            return
        } else if transportLabel.text == NSLocalizedString("Ex : Bus or Coach", comment: "") {
            self.showAlert(message: NSLocalizedString("Please input details of the means of transport.", comment: ""))
            return
        } else if serviceTextField.text == "" {
            self.showAlert(message: NSLocalizedString("Please input service or line number.", comment: ""))
            return
        } else if dateLabel.text == NSLocalizedString("Ex : dd/mm/yyyy", comment: "") {
            self.showAlert(message: NSLocalizedString("Please input date of the incident.", comment: ""))
            return
        } else if incidentDate! > date as Date {
            self.showAlert(message: NSLocalizedString("Date of the incident is invalid.", comment: ""))
            return
        } else if timeLabel.text == NSLocalizedString("Ex : hh:mm", comment: "") {
            self.showAlert(message: NSLocalizedString("Please input time of the incident.", comment: ""))
            return
        } else if incidentTime! > date as Date {
            self.showAlert(message: NSLocalizedString("Time of the incident is invalid.", comment: ""))
            return
        }
        
        GlobalData.incidentReport?.city = cityLabel.text!
        GlobalData.incidentReport?.transportMode = transportLabel.text!
        GlobalData.incidentReport?.serviceNumber = serviceTextField.text!
        GlobalData.incidentReport?.incidentDate = dateLabel.text!
        GlobalData.incidentReport?.incidentTime = timeLabel.text!
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep5ViewController") as! MAStep5ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
