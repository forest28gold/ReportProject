//
//  MAStep5ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MAStep5ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, ShowsAlert {

    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var memberLabel: UILabel!
    @IBOutlet var addMemberLabel: UILabel!
    @IBOutlet var addMemberStackView: UIStackView!
    @IBOutlet var desciptionLabel: UILabel!
    
    @IBOutlet var reportYesButton: UIButton!
    @IBOutlet var reportNoButton: UIButton!
    @IBOutlet var newMemberButton: UIButton!
    
    @IBOutlet var authorTableView: UITableView!
    
    @IBOutlet var dateView: UIView!
    @IBOutlet var dataPickerView: UIPickerView!
    
    var selectedIndex: IndexPath!
    
    var type = ""
    var peopleArray = ["0", "1", "2", "3", "4", "5", NSLocalizedString("5 or more", comment: "")]
    var genderArray = [NSLocalizedString("Man", comment: ""), NSLocalizedString("Woman", comment: ""),
                       NSLocalizedString("Transgender Man", comment: ""), NSLocalizedString("Transgender Woman", comment: ""),
                       NSLocalizedString("Other", comment: "")]
    var ageArray = [NSLocalizedString("18 years old", comment: ""), NSLocalizedString("18 to 30", comment: ""),
                    NSLocalizedString("31 to 40", comment: ""), NSLocalizedString("41 to 50", comment: ""),
                    NSLocalizedString("51 to 60", comment: ""), NSLocalizedString("61 and over", comment: "")]
    
    var hasAggressor = false
    
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
        
        addMemberLabel.isHidden = true
        addMemberStackView.isHidden = true
        desciptionLabel.isHidden = true
        newMemberButton.isHidden = true
        GlobalData.aggressorArray = [AggressorData]()
        hasAggressor = false
        
        initLoadEthnicData()
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
                                GlobalData.ethnicArray.append(name_fr)
                            } else {
                                GlobalData.ethnicArray.append(name)
                            }
                        }
                        GlobalData.ethnicArray.append(NSLocalizedString("Other", comment: ""))
                        self.dataPickerView.reloadAllComponents()
                    }
                }
            })
        }
    }
    
    //=================================
    
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
            return GlobalData.ethnicArray.count
        } else {
            return peopleArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if type == "gender" {
            return genderArray[row]
        } else if type == "age" {
            return ageArray[row]
        } else if type == "ethnic" {
            return GlobalData.ethnicArray[row]
        } else {
            return peopleArray[row]
        }
    }
    
    @IBAction func cancelPickerAction(_ sender: Any) {
        closeAnimationView(dateView)
    }
    
    @IBAction func donePickerAction(_ sender: Any) {
        closeAnimationView(dateView)
        
        if type == "gender" {
            var authorData = GlobalData.aggressorArray[selectedIndex.row]
            authorData.gender = genderArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.aggressorArray.remove(at: selectedIndex.row)
            GlobalData.aggressorArray.insert(authorData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = authorTableView.contentOffset
                authorTableView.reloadRows(at: [selectedIndex], with: .none)
                authorTableView.contentOffset = loc
            })
            
        } else if type == "age" {
            var authorData = GlobalData.aggressorArray[selectedIndex.row]
            authorData.age = ageArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.aggressorArray.remove(at: selectedIndex.row)
            GlobalData.aggressorArray.insert(authorData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = authorTableView.contentOffset
                authorTableView.reloadRows(at: [selectedIndex], with: .none)
                authorTableView.contentOffset = loc
            })
            
        } else if type == "ethnic" {
            var authorData = GlobalData.aggressorArray[selectedIndex.row]
            authorData.ethnic = GlobalData.ethnicArray[dataPickerView.selectedRow(inComponent: 0)]
            GlobalData.aggressorArray.remove(at: selectedIndex.row)
            GlobalData.aggressorArray.insert(authorData, at: selectedIndex.row)
            
            UIView.performWithoutAnimation({
                let loc = authorTableView.contentOffset
                authorTableView.reloadRows(at: [selectedIndex], with: .none)
                authorTableView.contentOffset = loc
            })
            
        } else {
            memberLabel.text = peopleArray[dataPickerView.selectedRow(inComponent: 0)]
            if memberLabel.text == "0" {
                addMemberLabel.isHidden = true
                addMemberStackView.isHidden = true
                desciptionLabel.isHidden = true
                newMemberButton.isHidden = true
                hasAggressor = false
                GlobalData.aggressorArray.removeAll()
                authorTableView.reloadData()
            } else {
                addMemberLabel.isHidden = false
                addMemberStackView.isHidden = false
                
                reportYesButton.backgroundColor = UIColor("#6a5bd0")
                reportNoButton.backgroundColor = UIColor("#E8EEF4")
                reportYesButton.setTitleColor(UIColor.white, for: .normal)
                reportNoButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
                hasAggressor = true
                
                desciptionLabel.isHidden = false
                newMemberButton.isHidden = false
                if GlobalData.aggressorArray.count == 0 {
                    let authorData = AggressorData.init(name: "", firstName: "", gender: "", age: "", ethnic: "", signs: "")
                    GlobalData.aggressorArray.append(authorData)
                    authorTableView.reloadData()
                }
            }
        }
    }
    
    //===================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func peopleButtonPressed(_ sender: Any) {
        type = "people"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @IBAction func reportAuthorYesButtonPressed(_ sender: Any) {
        
        reportYesButton.backgroundColor = UIColor("#6a5bd0")
        reportNoButton.backgroundColor = UIColor("#E8EEF4")
        reportYesButton.setTitleColor(UIColor.white, for: .normal)
        reportNoButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        
        desciptionLabel.isHidden = false
        newMemberButton.isHidden = false
        hasAggressor = true
        
        if GlobalData.aggressorArray.count == 0 {
            let authorData = AggressorData.init(name: "", firstName: "", gender: "", age: "", ethnic: "", signs: "")
            GlobalData.aggressorArray.append(authorData)
            authorTableView.reloadData()
        }
    }
    
    @IBAction func reportAuthorNoButtonPressed(_ sender: Any) {
        
        reportYesButton.backgroundColor = UIColor("#E8EEF4")
        reportNoButton.backgroundColor = UIColor("#6a5bd0")
        reportYesButton.setTitleColor(UIColor("#7C90A6"), for: .normal)
        reportNoButton.setTitleColor(UIColor.white, for: .normal)
        
        desciptionLabel.isHidden = true
        newMemberButton.isHidden = true
        hasAggressor = false
        GlobalData.aggressorArray.removeAll()
        authorTableView.reloadData()
    }
    
    @IBAction func addAnotherAuthorButtonPressed(_ sender: Any) {
        let authorData = AggressorData.init(name: "", firstName: "", gender: "", age: "", ethnic: "", signs: "")
        GlobalData.aggressorArray.append(authorData)
        authorTableView.reloadData()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let memberCount:Int! = Int(memberLabel.text!)
        
        if memberLabel.text == NSLocalizedString("Ex : 5", comment: "") {
            self.showAlert(message: NSLocalizedString("Please input people count.", comment: ""))
            return
        } else if memberLabel.text == "0" || !hasAggressor {
            GlobalData.incidentReport?.hasAggressor = false
            GlobalData.aggressorArray = [AggressorData]()
            nextMoveStep()
            return
        } else if memberLabel.text != NSLocalizedString("5 or more", comment: "") && memberCount < GlobalData.aggressorArray.count {
            self.showAlert(message: NSLocalizedString("You added more aggressors than people.", comment: ""))
            return
        } else if hasAggressor && GlobalData.aggressorArray.count == 0 {
            self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
            return
        } else {
            for aggressor in GlobalData.aggressorArray {
//                if aggressor.name == "" {
//                    self.showAlert(message: NSLocalizedString("Please input last name.", comment: ""))
//                    return
//                } else if aggressor.firstName == "" {
//                    self.showAlert(message: NSLocalizedString("Please input first name.", comment: ""))
//                    return
//                } else if aggressor.gender == "" {
//                    self.showAlert(message: NSLocalizedString("Please input gender expressed.", comment: ""))
//                    return
//                } else if aggressor.age == "" {
//                    self.showAlert(message: NSLocalizedString("Please input age.", comment: ""))
//                    return
//                } else if aggressor.ethnic == "" {
//                    self.showAlert(message: NSLocalizedString("Please input ethnic / culture background.", comment: ""))
//                    return
//                } else if aggressor.signs == "" {
//                    self.showAlert(message: NSLocalizedString("Please input distinctive signs.", comment: ""))
//                    return
//                }
                
                if aggressor.name == "" && aggressor.firstName == "" && aggressor.gender == "" && aggressor.age == "" && aggressor.ethnic == "" && aggressor.signs == "" {
                    self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
                    return
                }
            }
            GlobalData.incidentReport?.hasAggressor = true
            nextMoveStep()
        }
    }
    
    func nextMoveStep() {
        
        GlobalData.incidentReport?.peopleNumber = memberLabel.text!
        
        if GlobalData.incidentReport?.reportType == NSLocalizedString("Witness", comment: "") {
            GlobalData.incidentReport?.isVictim = false
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep61ViewController") as! MAStep61ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            GlobalData.incidentReport?.isVictim = true
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep6ViewController") as! MAStep6ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    //===================================
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.aggressorArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 423
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath as IndexPath)
        
        let authorButton = cell.viewWithTag(1) as? UIButton
        let nameButton = cell.viewWithTag(2) as? UIButton
        let firstNameButton = cell.viewWithTag(3) as? UIButton
        let genderButton = cell.viewWithTag(4) as? UIButton
        let ageButton = cell.viewWithTag(5) as? UIButton
        let ethnicButton = cell.viewWithTag(6) as? UIButton
        let signsButton = cell.viewWithTag(7) as? UIButton
        let removeButton = cell.viewWithTag(12) as? UIButton
        
        let nameLable = cell.viewWithTag(21) as? UILabel
        let firstNameLable = cell.viewWithTag(31) as? UILabel
        let genderLable = cell.viewWithTag(41) as? UILabel
        let ageLable = cell.viewWithTag(51) as? UILabel
        let ethnicLable = cell.viewWithTag(61) as? UILabel
        let signsLable = cell.viewWithTag(71) as? UILabel
        
        nameButton?.addTarget(self, action: #selector(self.nameButtonClicked), for: .touchUpInside)
        firstNameButton?.addTarget(self, action: #selector(self.firstNameButtonClicked), for: .touchUpInside)
        genderButton?.addTarget(self, action: #selector(self.genderButtonClicked), for: .touchUpInside)
        ageButton?.addTarget(self, action: #selector(self.ageButtonClicked), for: .touchUpInside)
        ethnicButton?.addTarget(self, action: #selector(self.ethnicButtonClicked), for: .touchUpInside)
        signsButton?.addTarget(self, action: #selector(self.signsButtonClicked), for: .touchUpInside)
        removeButton?.addTarget(self, action: #selector(self.removeButtonClicked), for: .touchUpInside)
        
        authorButton?.setTitle(NSLocalizedString("Aggressor", comment: "") + " " + String(indexPath.row + 1), for: .normal)
        nameLable?.text = GlobalData.aggressorArray[indexPath.row].name
        firstNameLable?.text = GlobalData.aggressorArray[indexPath.row].firstName
        genderLable?.text = GlobalData.aggressorArray[indexPath.row].gender
        ageLable?.text = GlobalData.aggressorArray[indexPath.row].age
        ethnicLable?.text = GlobalData.aggressorArray[indexPath.row].ethnic
        signsLable?.text = GlobalData.aggressorArray[indexPath.row].signs
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    //---------------
    
    @objc func nameButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: authorTableView)
        selectedIndex = authorTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)

        type = "name"
        closeAnimationView(dateView)
        
        let alertController = UIAlertController(title: NSLocalizedString("Last name", comment: ""), message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {
            alert -> Void in
            
            let nameTextField = alertController.textFields![0] as UITextField
            if nameTextField.text != "" {
                var authorData = GlobalData.aggressorArray[self.selectedIndex.row]
                authorData.name = nameTextField.text!
                GlobalData.aggressorArray.remove(at: self.selectedIndex.row)
                GlobalData.aggressorArray.insert(authorData, at: self.selectedIndex.row)
                
                UIView.performWithoutAnimation({
                    let loc = self.authorTableView.contentOffset
                    self.authorTableView.reloadRows(at: [self.selectedIndex], with: .none)
                    self.authorTableView.contentOffset = loc
                })
                
            } else {
                // Show Alert Message to User As per you want
                
                let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please input last name.", comment: ""), preferredStyle: .alert)
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
            textField.autocapitalizationType = .words
        }
        // add the actions (buttons)
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        // show the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func firstNameButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: authorTableView)
        selectedIndex = authorTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        type = "firstName"
        closeAnimationView(dateView)
        
        let alertController = UIAlertController(title: NSLocalizedString("First Name", comment: ""), message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {
            alert -> Void in
            
            let firstNameTextField = alertController.textFields![0] as UITextField
            if firstNameTextField.text != "" {
                var authorData = GlobalData.aggressorArray[self.selectedIndex.row]
                authorData.firstName = firstNameTextField.text!
                GlobalData.aggressorArray.remove(at: self.selectedIndex.row)
                GlobalData.aggressorArray.insert(authorData, at: self.selectedIndex.row)
                
                UIView.performWithoutAnimation({
                    let loc = self.authorTableView.contentOffset
                    self.authorTableView.reloadRows(at: [self.selectedIndex], with: .none)
                    self.authorTableView.contentOffset = loc
                })
                
            } else {
                // Show Alert Message to User As per you want
                
                let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please input first name.", comment: ""), preferredStyle: .alert)
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
            textField.autocapitalizationType = .words
        }
        // add the actions (buttons)
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        // show the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func genderButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: authorTableView)
        selectedIndex = authorTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)

        type = "gender"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @objc func ageButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: authorTableView)
        selectedIndex = authorTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)

        type = "age"
        dataPickerView.reloadAllComponents()
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @objc func ethnicButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: authorTableView)
        selectedIndex = authorTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
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
            query.findObjectsInBackground (block: { (objects, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            
                            if GlobalData.currentLocale == Constants.LOCALE_FR {
                                GlobalData.ethnicArray.append(name_fr)
                            } else {
                                GlobalData.ethnicArray.append(name)
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
    
    @objc func signsButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: authorTableView)
        selectedIndex = authorTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        type = "signs"
        closeAnimationView(dateView)
        
        let alertController = UIAlertController(title: NSLocalizedString("Distinctive Signs", comment: ""), message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {
            alert -> Void in
            
            let signsTextField = alertController.textFields![0] as UITextField
            if signsTextField.text != "" {
                var authorData = GlobalData.aggressorArray[self.selectedIndex.row]
                authorData.signs = signsTextField.text!
                GlobalData.aggressorArray.remove(at: self.selectedIndex.row)
                GlobalData.aggressorArray.insert(authorData, at: self.selectedIndex.row)
                
                UIView.performWithoutAnimation({
                    let loc = self.authorTableView.contentOffset
                    self.authorTableView.reloadRows(at: [self.selectedIndex], with: .none)
                    self.authorTableView.contentOffset = loc
                })
                
            } else {
                // Show Alert Message to User As per you want
                
                let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please input distinctive signs.", comment: ""), preferredStyle: .alert)
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
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: authorTableView)
        var indexPath: IndexPath? = authorTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("You are going to remove this author description.", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: UIAlertActionStyle.default, handler: { action in
            GlobalData.aggressorArray.remove(at: (indexPath?.row)!)
            self.authorTableView.reloadData()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
