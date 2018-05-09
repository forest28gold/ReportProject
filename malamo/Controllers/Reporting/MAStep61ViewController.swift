//
//  MAStep61ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MAStep61ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, ShowsAlert {

    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var desciptionLabel: UILabel!
    @IBOutlet var reportYesButton: UIButton!
    @IBOutlet var reportNoButton: UIButton!
    @IBOutlet var newMemberButton: UIButton!    
    @IBOutlet var victimTableView: UITableView!

    var selectedIndex: IndexPath!
    
    @IBOutlet var dateView: UIView!
    @IBOutlet var dataPickerView: UIPickerView!
    
    var type = ""
    var knownArray = [NSLocalizedString("Yes", comment: ""), NSLocalizedString("No", comment: "")]
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
    
    var hasVictim = true
    
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
        
        reportYesButton.backgroundColor = UIColor("#6a5bd0")
        reportNoButton.backgroundColor = UIColor("#E8EEF4")
        reportYesButton.setTitleColor(UIColor.white, for: .normal)
        reportNoButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        
        desciptionLabel.isHidden = false
        newMemberButton.isHidden = false
        GlobalData.victimArray = [VictimData]()
        let victimData = VictimData.init(known: "", relation: "", gender: "", age: "", ethnic: "", sexual: "", religion: "", language: "", consider: "", others: "")
        GlobalData.victimArray.append(victimData)
        victimTableView.reloadData()
        
        initLoadRelationData()
        initLoadEthnicData()
        initLoadReligionData()
        initLoadMotherTongueData()
        
        hasVictim = true
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
    
    func initLoadRelationData() {
        
        if GlobalData.relationshipArray.count > 0 {
            
        } else {
            let query = PFQuery(className: Constants.CLASS_VICTIM_RELATIONSHIP)
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
                            
                            let pickerData = PickerData.init(name: name, name_fr: name_fr)
                            GlobalData.relationshipArray.append(pickerData)
                        }
                        self.dataPickerView.reloadAllComponents()
                    }
                }
            })
        }
    }
    
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
        } else if type == "known" {
            return knownArray.count
        } else if type == "relation" {
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                return GlobalData.relationshipArray.count
            } else {
                return GlobalData.relationshipArray.count
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
        } else if type == "known" {
            return knownArray[row]
        } else if type == "relation" {
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                return GlobalData.relationshipArray[row].name_fr
            } else {
                return GlobalData.relationshipArray[row].name
            }
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
            var victimData = GlobalData.victimArray[selectedIndex.row]
            victimData.gender = genderArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
            
        } else if type == "age" {
            var victimData = GlobalData.victimArray[selectedIndex.row]
            victimData.age = ageArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
            
        } else if type == "ethnic" {
            var victimData = GlobalData.victimArray[selectedIndex.row]
            victimData.ethnic = GlobalData.ethnicArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
            
        } else if type == "orientation" {
            var victimData = GlobalData.victimArray[selectedIndex.row]
            victimData.sexual = orientationArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
            
        } else if type == "religion" {
            var victimData = GlobalData.victimArray[selectedIndex.row]
            victimData.religion = GlobalData.religionArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
            
        } else if type == "language" {
            var victimData = GlobalData.victimArray[selectedIndex.row]
            victimData.language = GlobalData.motherTongueArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
            
        } else if type == "known" {
            var victimData = GlobalData.victimArray[selectedIndex.row]
            victimData.known = knownArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
            
        } else if type == "relation" {
            var victimData = GlobalData.victimArray[selectedIndex.row]
            if GlobalData.currentLocale == Constants.LOCALE_FR {
                victimData.relation = GlobalData.relationshipArray[dataPickerView.selectedRow(inComponent: 0)].name_fr
            } else {
                victimData.relation = GlobalData.relationshipArray[dataPickerView.selectedRow(inComponent: 0)].name
            }
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
            
        } else {
            var victimData = GlobalData.victimArray[selectedIndex.row]
            victimData.consider = considerArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.victimArray.remove(at: selectedIndex.row)
            GlobalData.victimArray.insert(victimData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = self.victimTableView.contentOffset
                self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                self.victimTableView.contentOffset = loc
            })
        }
    }
    
    //===================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addVictimYesButtonPressed(_ sender: Any) {
        reportYesButton.backgroundColor = UIColor("#6a5bd0")
        reportNoButton.backgroundColor = UIColor("#E8EEF4")
        reportYesButton.setTitleColor(UIColor.white, for: .normal)
        reportNoButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        
        desciptionLabel.isHidden = false
        newMemberButton.isHidden = false
        
        hasVictim = true
        
        if GlobalData.victimArray.count == 0 {
            let victimData = VictimData.init(known: "", relation: "", gender: "", age: "", ethnic: "", sexual: "", religion: "", language: "", consider: "", others: "")
            GlobalData.victimArray.append(victimData)
            victimTableView.reloadData()
        }
    }
    
    @IBAction func addVictimNoButtonPressed(_ sender: Any) {
        reportYesButton.backgroundColor = UIColor("#E8EEF4")
        reportNoButton.backgroundColor = UIColor("#6a5bd0")
        reportYesButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        reportNoButton.setTitleColor(UIColor.white, for: .normal)
        
        desciptionLabel.isHidden = true
        newMemberButton.isHidden = true
        
        hasVictim = false
        
        GlobalData.victimArray.removeAll()
        victimTableView.reloadData()
    }
    
    @IBAction func addAnotherVictimButtonPressed(_ sender: Any) {
        let victimData = VictimData.init(known: "", relation: "", gender: "", age: "", ethnic: "", sexual: "", religion: "", language: "", consider: "", others: "")
        GlobalData.victimArray.append(victimData)
        victimTableView.reloadData()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if !hasVictim {
            GlobalData.incidentReport?.hasVictim = false
            GlobalData.victimArray = [VictimData]()
        } else {
            
            if GlobalData.victimArray.count == 0 {
                self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
                return
            }
            
            GlobalData.incidentReport?.hasVictim = true
            
            for victim in GlobalData.victimArray {
//                if victim.known == "" {
//                    self.showAlert(message: NSLocalizedString("Do you know the victim?", comment: ""))
//                    return
//                } else if victim.relation == "" {
//                    self.showAlert(message: NSLocalizedString("What is your relationship with the victim?", comment: ""))
//                    return
//                } else if victim.gender == "" {
//                    self.showAlert(message: NSLocalizedString("Please input gender expressed.", comment: ""))
//                    return
//                } else if victim.age == "" {
//                    self.showAlert(message: NSLocalizedString("Please input age.", comment: ""))
//                    return
//                } else if victim.ethnic == "" {
//                    self.showAlert(message: NSLocalizedString("Please input ethnic / culture background.", comment: ""))
//                    return
//                } else if victim.sexual == "" {
//                    self.showAlert(message: NSLocalizedString("Please input sexual orientation.", comment: ""))
//                    return
//                } else if victim.religion == "" {
//                    self.showAlert(message: NSLocalizedString("Please input religion.", comment: ""))
//                    return
//                } else if victim.language == "" {
//                    self.showAlert(message: NSLocalizedString("Please input language.", comment: ""))
//                    return
//                } else if victim.consider == "" {
//                    self.showAlert(message: NSLocalizedString("Do you consider yourself to be affected by a mental or physical disability?", comment: ""))
//                    return
//                } else if victim.others == "" {
//                    self.showAlert(message: NSLocalizedString("Please input other relevant information.", comment: ""))
//                    return
//                }
                
                if victim.known == "" && victim.relation == "" && victim.gender == "" && victim.age == "" && victim.ethnic == "" &&
                    victim.sexual == "" && victim.religion == "" && victim.language == "" && victim.consider == "" && victim.others == "" {
                    self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
                    return
                }
            }
        }
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep7ViewController") as! MAStep7ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //===================================

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.victimArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 673
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VictimCell", for: indexPath as IndexPath)
        
        let victimButton = cell.viewWithTag(1) as? UIButton
        let knownButton = cell.viewWithTag(2) as? UIButton
        let relationButton = cell.viewWithTag(3) as? UIButton
        let genderButton = cell.viewWithTag(4) as? UIButton
        let ageButton = cell.viewWithTag(5) as? UIButton
        let ethnicButton = cell.viewWithTag(6) as? UIButton
        let sexualButton = cell.viewWithTag(7) as? UIButton
        let religionButton = cell.viewWithTag(8) as? UIButton
        let languageButton = cell.viewWithTag(9) as? UIButton
        let considerButton = cell.viewWithTag(10) as? UIButton
        let othersButton = cell.viewWithTag(11) as? UIButton
        let removeButton = cell.viewWithTag(12) as? UIButton
        
        let knownLable = cell.viewWithTag(21) as? UILabel
        let relationLable = cell.viewWithTag(31) as? UILabel
        let genderLable = cell.viewWithTag(41) as? UILabel
        let ageLable = cell.viewWithTag(51) as? UILabel
        let ethnicLable = cell.viewWithTag(61) as? UILabel
        let sexualLable = cell.viewWithTag(71) as? UILabel
        let religionLable = cell.viewWithTag(81) as? UILabel
        let languageLable = cell.viewWithTag(91) as? UILabel
        let considerLable = cell.viewWithTag(101) as? UILabel
        let othersLable = cell.viewWithTag(111) as? UILabel
        
        knownButton?.addTarget(self, action: #selector(self.knownButtonClicked), for: .touchUpInside)
        relationButton?.addTarget(self, action: #selector(self.relationButtonClicked), for: .touchUpInside)
        genderButton?.addTarget(self, action: #selector(self.genderButtonClicked), for: .touchUpInside)
        ageButton?.addTarget(self, action: #selector(self.ageButtonClicked), for: .touchUpInside)
        ethnicButton?.addTarget(self, action: #selector(self.ethnicButtonClicked), for: .touchUpInside)
        sexualButton?.addTarget(self, action: #selector(self.sexualButtonClicked), for: .touchUpInside)
        religionButton?.addTarget(self, action: #selector(self.religionButtonClicked), for: .touchUpInside)
        languageButton?.addTarget(self, action: #selector(self.languageButtonClicked), for: .touchUpInside)
        considerButton?.addTarget(self, action: #selector(self.considerButtonClicked), for: .touchUpInside)
        othersButton?.addTarget(self, action: #selector(self.othersButtonClicked), for: .touchUpInside)
        removeButton?.addTarget(self, action: #selector(self.removeButtonClicked), for: .touchUpInside)
        
        victimButton?.setTitle(NSLocalizedString("Victim", comment: "") + " " + String(indexPath.row + 1), for: .normal)
        knownLable?.text = GlobalData.victimArray[indexPath.row].known
        relationLable?.text = GlobalData.victimArray[indexPath.row].relation
        genderLable?.text = GlobalData.victimArray[indexPath.row].gender
        ageLable?.text = GlobalData.victimArray[indexPath.row].age
        ethnicLable?.text = GlobalData.victimArray[indexPath.row].ethnic
        sexualLable?.text = GlobalData.victimArray[indexPath.row].sexual
        religionLable?.text = GlobalData.victimArray[indexPath.row].religion
        languageLable?.text = GlobalData.victimArray[indexPath.row].language
        considerLable?.text = GlobalData.victimArray[indexPath.row].consider
        othersLable?.text = GlobalData.victimArray[indexPath.row].others
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    //---------------
    
    @objc func knownButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)

        type = "known"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @objc func relationButtonClicked(_ sender: Any) {
        
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        if GlobalData.relationshipArray.count > 0 {
            type = "relation"
            dataPickerView.reloadAllComponents()
            if dateView.isHidden == true {
                showAnimationView(dateView)
            }
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_VICTIM_RELATIONSHIP)
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
                            
                            let pickerData = PickerData.init(name: name, name_fr: name_fr)
                            GlobalData.relationshipArray.append(pickerData)
                        }
                        self.type = "relation"
                        self.dataPickerView.reloadAllComponents()
                        if self.dateView.isHidden == true {
                            self.showAnimationView(self.dateView)
                        }
                    }
                }
            })
        }
        
        
    }
    
    @objc func genderButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        type = "gender"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @objc func ageButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        type = "age"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @objc func ethnicButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
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
                        if  self.dateView.isHidden == true {
                             self.showAnimationView( self.dateView)
                        }
                    }
                }
            })
        }
    }
    
    @objc func sexualButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        type = "orientation"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @objc func religionButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
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
    
    @objc func languageButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        if GlobalData.motherTongueArray.count > 0 {
            type = "language"
            dataPickerView.reloadAllComponents()
            if dateView.isHidden == true {
                showAnimationView(dateView)
            }
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
    
    @objc func considerButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)

        type = "consider"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @objc func othersButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        selectedIndex = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)

        type = "others"
        closeAnimationView(dateView)
        
        let alertController = UIAlertController(title: NSLocalizedString("Other relevant information", comment: ""), message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {
            alert -> Void in
            
            let othersTextField = alertController.textFields![0] as UITextField
            if othersTextField.text != "" {
                var victimData = GlobalData.victimArray[self.selectedIndex.row]
                victimData.others = othersTextField.text!
                GlobalData.victimArray.remove(at: self.selectedIndex.row)
                GlobalData.victimArray.insert(victimData, at: self.selectedIndex.row)
                
                UIView.performWithoutAnimation({
                    let loc = self.victimTableView.contentOffset
                    self.victimTableView.reloadRows(at: [self.selectedIndex], with: .none)
                    self.victimTableView.contentOffset = loc
                })
                
            } else {
                // Show Alert Message to User As per you want
                
                let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please input other relevant information.", comment: ""), preferredStyle: .alert)
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
            textField.font = UIFont.systemFont(ofSize: 14)
            textField.returnKeyType = UIReturnKeyType.done
            textField.autocapitalizationType = .sentences
        }
        // add the actions (buttons)
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        // show the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func removeButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: victimTableView)
        var indexPath: IndexPath? = victimTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("You are going to remove this victim description.", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: UIAlertActionStyle.default, handler: { action in
            GlobalData.victimArray.remove(at: (indexPath?.row)!)
            self.victimTableView.reloadData()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
