//
//  MAStep6ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MAStep6ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ShowsAlert {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var ethnicLabel: UILabel!
    @IBOutlet var orientationLabel: UILabel!
    @IBOutlet var religionLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var considerLabel: UILabel!
    
    @IBOutlet var dateView: UIView!
    @IBOutlet var dataPickerView: UIPickerView!
    
    var type = ""
    var genderArray = [NSLocalizedString("Man", comment: ""), NSLocalizedString("Woman", comment: ""),
                       NSLocalizedString("Transgender Man", comment: ""), NSLocalizedString("Transgender Woman", comment: ""),
                       NSLocalizedString("Other", comment: "")]
    var ageArray = [NSLocalizedString("18 years old", comment: ""), NSLocalizedString("18 to 30", comment: ""),
                    NSLocalizedString("31 to 40", comment: ""), NSLocalizedString("41 to 50", comment: ""),
                    NSLocalizedString("51 to 60", comment: ""), NSLocalizedString("61 and over", comment: "")]
    var orientationArray = [NSLocalizedString("Heterosexual", comment: ""), NSLocalizedString("Homosexual", comment: ""),
                            NSLocalizedString("Bisexual", comment: ""), NSLocalizedString("Asexual", comment: ""),
                            NSLocalizedString("Other", comment: "")]
    var considerArray = [NSLocalizedString("Mental handicap", comment: ""), NSLocalizedString("Physical and mental handicap", comment: ""),
                         NSLocalizedString("No handicap", comment: ""), NSLocalizedString("No answer", comment: "")]

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
        
        genderLabel.text = ""
        ageLabel.text = ""
        ethnicLabel.text = ""
        orientationLabel.text = ""
        religionLabel.text = ""
        languageLabel.text = ""
        considerLabel.text = ""
        
        initLoadEthnicData()
        initLoadReligionData()
        initLoadMotherTongueData()
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
    
    //==============================
    
    func initLoadEthnicData() {
        
        if GlobalData.ethnicArray.count > 0 {
            
        } else {
            let query = PFQuery(className: Constants.CLASS_ETHNIC)
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                query.order(byAscending: "name_fr")
            } else {
                query.order(byAscending: "name")
            }
            query.limit = Constants.QUERY_LIMIT
            query.findObjectsInBackground (block: { (objects, error) in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            if GlobalData.currentLocale == Constants.LOCALE_FR {
                                if name_fr != "" {
                                    GlobalData.ethnicArray.append(name_fr)
                                }
                            } else {
                                if name != "" {
                                    GlobalData.ethnicArray.append(name)
                                }
                            }
                        }
                        GlobalData.ethnicArray.append(NSLocalizedString("Other", comment: ""))
                        self.dataPickerView.reloadAllComponents()
                    }
                }
            })
        }
    }
    
    func initLoadReligionData() {
        
        if GlobalData.religionArray.count > 0 {
            
        } else {
            let query = PFQuery(className: Constants.CLASS_RELIGION)
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                query.order(byAscending: "name_fr")
            } else {
                query.order(byAscending: "name")
            }
            query.limit = Constants.QUERY_LIMIT
            query.findObjectsInBackground (block: { (objects, error) in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            if GlobalData.currentLocale == Constants.LOCALE_FR {
                                if name_fr != "" {
                                    GlobalData.religionArray.append(name_fr)
                                }
                            } else {
                                if name != "" {
                                    GlobalData.religionArray.append(name)
                                }
                            }
                        }
                        GlobalData.religionArray.append(NSLocalizedString("Other religion", comment: ""))
                        GlobalData.religionArray.append(NSLocalizedString("No religious affiliation", comment: ""))
                        self.dataPickerView.reloadAllComponents()
                    }
                }
            })
        }
    }
    
    func initLoadMotherTongueData() {
        
        if GlobalData.motherTongueArray.count > 0 {
            
        } else {
            let query = PFQuery(className: Constants.CLASS_MOTHER_TONGUE)
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                query.order(byAscending: "name_fr")
            } else {
                query.order(byAscending: "name")
            }
            query.limit = Constants.QUERY_LIMIT
            query.findObjectsInBackground (block: { (objects, error) in
                if error == nil {
                    if let objects = objects {
                        GlobalData.motherTongueArray.append(NSLocalizedString("French", comment: ""))
                        GlobalData.motherTongueArray.append(NSLocalizedString("English", comment: ""))
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            if GlobalData.currentLocale == Constants.LOCALE_FR {
                                if name_fr != "" {
                                    GlobalData.motherTongueArray.append(name_fr)
                                }
                            } else {
                                if name != "" {
                                    GlobalData.motherTongueArray.append(name)
                                }
                            }
                        }
                        GlobalData.motherTongueArray.append(NSLocalizedString("Other language", comment: ""))
                        self.dataPickerView.reloadAllComponents()
                    }
                }
            })
        }
    }
    
    //==============================
    
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
        if type == "gender" {
            return genderArray.count
        } else if type == "age" {
            return ageArray.count
        } else if type == "ethnic" {
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                return GlobalData.ethnicArray.count
            } else {
                return GlobalData.ethnicArray.count
            }
        } else if type == "orientation" {
            return orientationArray.count
        } else if type == "religion" {
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                return GlobalData.religionArray.count
            } else {
                return GlobalData.religionArray.count
            }
        } else if type == "language" {
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                return GlobalData.motherTongueArray.count
            } else {
                return GlobalData.motherTongueArray.count
            }
        } else {
            return considerArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if type == "gender" {
            return genderArray[row]
        } else if type == "age" {
            return ageArray[row]
        } else if type == "ethnic" {
            return GlobalData.ethnicArray[row]
        } else if type == "orientation" {
            return orientationArray[row]
        } else if type == "religion" {
            return GlobalData.religionArray[row]
        } else if type == "language" {
            return GlobalData.motherTongueArray[row]
        } else {
            return considerArray[row]
        }
    }
    
    @IBAction func cancelPickerAction(_ sender: Any) {
        closeAnimationView(dateView)
    }
    
    @IBAction func donePickerAction(_ sender: Any) {
        closeAnimationView(dateView)
        
        if type == "gender" {
            genderLabel.text = genderArray[dataPickerView.selectedRow(inComponent: 0)]
        } else if type == "age" {
            ageLabel.text = ageArray[dataPickerView.selectedRow(inComponent: 0)]
        } else if type == "ethnic" {
            ethnicLabel.text = GlobalData.ethnicArray[dataPickerView.selectedRow(inComponent: 0)]
        } else if type == "orientation" {
            orientationLabel.text = orientationArray[dataPickerView.selectedRow(inComponent: 0)]
        } else if type == "religion" {
            religionLabel.text = GlobalData.religionArray[dataPickerView.selectedRow(inComponent: 0)]
        } else if type == "language" {
            languageLabel.text = GlobalData.motherTongueArray[dataPickerView.selectedRow(inComponent: 0)]
        } else {
            considerLabel.text = considerArray[dataPickerView.selectedRow(inComponent: 0)]
        }
    }
    
    //===================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func genderButtonPressed(_ sender: Any) {
        type = "gender"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @IBAction func ageButtonPressed(_ sender: Any) {
        type = "age"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @IBAction func ethnicButtonPressed(_ sender: Any) {
        
        if GlobalData.ethnicArray.count > 0 {
            type = "ethnic"
            dataPickerView.reloadAllComponents()
            if dateView.isHidden == true {
                showAnimationView(dateView)
            }
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_ETHNIC)
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                query.order(byAscending: "name_fr")
            } else {
                query.order(byAscending: "name")
            }
            query.limit = Constants.QUERY_LIMIT
            query.findObjectsInBackground (block: { (objects, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            if GlobalData.currentLocale == Constants.LOCALE_FR {
                                if name_fr != "" {
                                    GlobalData.ethnicArray.append(name_fr)
                                }
                            } else {
                                if name != "" {
                                    GlobalData.ethnicArray.append(name)
                                }
                            }
                        }
                        GlobalData.ethnicArray.append(NSLocalizedString("Other", comment: ""))
                        self.type = "ethnic"
                        self.dataPickerView.reloadAllComponents()
                        if self.dateView.isHidden == true {
                            self.showAnimationView(self.dateView)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func orientationButtonPressed(_ sender: Any) {
        type = "orientation"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @IBAction func religionButtonPressed(_ sender: Any) {
        
        if GlobalData.religionArray.count > 0 {
            type = "religion"
            dataPickerView.reloadAllComponents()
            if dateView.isHidden == true {
                showAnimationView(dateView)
            }
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_RELIGION)
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                query.order(byAscending: "name_fr")
            } else {
                query.order(byAscending: "name")
            }
            query.limit = Constants.QUERY_LIMIT
            query.findObjectsInBackground (block: { (objects, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            if GlobalData.currentLocale == Constants.LOCALE_FR {
                                if name_fr != "" {
                                    GlobalData.religionArray.append(name_fr)
                                }
                            } else {
                                if name != "" {
                                    GlobalData.religionArray.append(name)
                                }
                            }
                        }
                        GlobalData.religionArray.append(NSLocalizedString("Other religion", comment: ""))
                        GlobalData.religionArray.append(NSLocalizedString("No religious affiliation", comment: ""))
                        self.type = "religion"
                        self.dataPickerView.reloadAllComponents()
                        if self.dateView.isHidden == true {
                            self.showAnimationView(self.dateView)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func languageButtonPressed(_ sender: Any) {
        
        if GlobalData.motherTongueArray.count > 0 {
            type = "language"
            dataPickerView.reloadAllComponents()
            if dateView.isHidden == true {
                showAnimationView(dateView)
            }
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_MOTHER_TONGUE)
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                query.order(byAscending: "name_fr")
            } else {
                query.order(byAscending: "name")
            }
            query.limit = Constants.QUERY_LIMIT
            query.findObjectsInBackground (block: { (objects, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    if let objects = objects {
                        GlobalData.motherTongueArray.append(NSLocalizedString("French", comment: ""))
                        GlobalData.motherTongueArray.append(NSLocalizedString("English", comment: ""))
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            if GlobalData.currentLocale == Constants.LOCALE_FR {
                                if name_fr != "" {
                                    GlobalData.motherTongueArray.append(name_fr)
                                }
                            } else {
                                if name != "" {
                                    GlobalData.motherTongueArray.append(name)
                                }
                            }
                        }
                        GlobalData.motherTongueArray.append(NSLocalizedString("Other language", comment: ""))
                        self.type = "language"
                        self.dataPickerView.reloadAllComponents()
                        if self.dateView.isHidden == true {
                            self.showAnimationView(self.dateView)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func considerButtonPressed(_ sender: Any) {
        type = "consider"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
//        if genderLabel.text == NSLocalizedString("Ex : Man", comment: "") {
//            self.showAlert(message: NSLocalizedString("Please input gender expressed.", comment: ""))
//            return
//        } else if ageLabel.text == NSLocalizedString("Ex : 18 to 30", comment: "") {
//            self.showAlert(message: NSLocalizedString("Please input age.", comment: ""))
//            return
//        } else if ethnicLabel.text == NSLocalizedString("Ex : Canadian", comment: "") {
//            self.showAlert(message: NSLocalizedString("Please input ethnic / culture background.", comment: ""))
//            return
//        } else if orientationLabel.text == NSLocalizedString("Ex : Heterosexual", comment: "") {
//            self.showAlert(message: NSLocalizedString("Please input sexual orientation.", comment: ""))
//            return
//        } else if religionLabel.text == NSLocalizedString("Ex : Atheist", comment: "") {
//            self.showAlert(message: NSLocalizedString("Please input religion.", comment: ""))
//            return
//        } else if languageLabel.text == NSLocalizedString("Ex : English", comment: "") {
//            self.showAlert(message: NSLocalizedString("Please input language.", comment: ""))
//            return
//        } else if considerLabel.text == NSLocalizedString("Ex : Handicap mental", comment: "") {
//            self.showAlert(message: NSLocalizedString("Do you consider yourself to be affected by a mental or physical disability?", comment: ""))
//            return
//        }
        
        if genderLabel.text == "" && ageLabel.text == "" && ethnicLabel.text == "" && orientationLabel.text == "" &&
            religionLabel.text == "" && languageLabel.text == "" && considerLabel.text == "" {
            self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
            return
        }
        
        GlobalData.victimArray = [VictimData]()
        let victim = VictimData.init(known: "", relation: "", gender: genderLabel.text!, age: ageLabel.text!, ethnic: ethnicLabel.text!, sexual: orientationLabel.text!, religion: religionLabel.text!, language: languageLabel.text!, consider: considerLabel.text!, others: "")
        GlobalData.victimArray.append(victim)

        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep7ViewController") as! MAStep7ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
