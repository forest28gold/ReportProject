//
//  MAStep2ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import Parse
import SDWebImage
import SVProgressHUD

class MAStep2ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ShowsAlert {

    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    
    @IBOutlet weak var factorCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
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

        initFactorData()
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
    
    
    func initFactorData() {
        if GlobalData.factorArray.count > 0 {
            for i in 0...GlobalData.factorArray.count - 1 {
                if GlobalData.factorArray[i].isSelected {
                    GlobalData.factorArray[i].isSelected = false
                }
            }
            self.factorCollectionView.reloadData()
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_INCIDENT_REASON)
            query.order(byAscending: "order")
            query.findObjectsInBackground (block: { (objects, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let objectId = object.objectId
                            let name = GlobalData.onCheckStringNull(object: object, key: "name")
                            let info_title = GlobalData.onCheckStringNull(object: object, key: "info_title")
                            let info = GlobalData.onCheckStringNull(object: object, key: "info")
                            let example = GlobalData.onCheckStringNull(object: object, key: "example")
                            let legal = GlobalData.onCheckStringNull(object: object, key: "legal")
                            let name_fr = GlobalData.onCheckStringNull(object: object, key: "name_fr")
                            let info_title_fr = GlobalData.onCheckStringNull(object: object, key: "info_title_fr")
                            let info_fr = GlobalData.onCheckStringNull(object: object, key: "info_fr")
                            let example_fr = GlobalData.onCheckStringNull(object: object, key: "example_fr")
                            let legal_fr = GlobalData.onCheckStringNull(object: object, key: "legal_fr")
                            let icon_img_url = GlobalData.onCheckFileNull(object: object, key: "icon_img")
                            let icon_info_img_url = GlobalData.onCheckFileNull(object: object, key: "icon_info_img")
                            
                            let factorData: FactorData = FactorData.init(objectId: objectId!, name: name, info: info, info_title: info_title, example: example, legal: legal, name_fr: name_fr, info_title_fr: info_title_fr, info_fr: info_fr, example_fr: example_fr, legal_fr: legal_fr, icon_img: icon_img_url, icon_info_img: icon_info_img_url, isSelected: false)
                            GlobalData.factorArray.append(factorData)
                        }
                        self.factorCollectionView.reloadData()
                    }
                } else {
                    
                }
            })
        }
    }
    
    //===================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        GlobalData.incidentReasonIds = [String]()
        var selectedCount = 0
        
        for factor in GlobalData.factorArray {
            if factor.isSelected {
                if GlobalData.currentLocale == Constants.LOCALE_FR {
                    GlobalData.incidentReasonIds.append(factor.name_fr)
                } else {
                    GlobalData.incidentReasonIds.append(factor.name)
                }
                selectedCount = selectedCount + 1
            }
        }
        
        if selectedCount == 0 {
            self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
            return
        }
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep3ViewController") as! MAStep3ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //===================================

    // MARK: - UICollectionViewDataSource protocol
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalData.factorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 3 - 0.8, height: self.view.frame.width / 3 - 0.8)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FactorCell", for: indexPath as IndexPath)
        
        let nameLable = cell.viewWithTag(1) as? UILabel
        let factorImage = cell.viewWithTag(2) as? UIImageView
        let infoButton = cell.viewWithTag(3) as? UIButton
        let backView = cell.viewWithTag(4)
        
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            nameLable?.text = GlobalData.factorArray[indexPath.row].name_fr
        } else {
            nameLable?.text = GlobalData.factorArray[indexPath.row].name
        }
        
        factorImage?.sd_setImage(with: URL(string: GlobalData.factorArray[indexPath.row].icon_img), placeholderImage: UIImage(named: "ic_placeholder"))
        infoButton?.addTarget(self, action: #selector(self.infoButtonClicked), for: .touchUpInside)
        
        if GlobalData.factorArray[indexPath.row].isSelected {
            backView?.backgroundColor = UIColor("#6a5bd0")
        } else {
            backView?.backgroundColor = UIColor("#20252b")
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        if GlobalData.factorArray[indexPath.row].isSelected {
            GlobalData.factorArray[indexPath.row].isSelected = false
        } else {
            GlobalData.factorArray[indexPath.row].isSelected = true
        }
        factorCollectionView.reloadData()
    }
    
    @objc func infoButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: factorCollectionView)
        var indexPath: IndexPath? = factorCollectionView.indexPathForItem(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAInformationViewController") as! MAInformationViewController
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            nextViewController.strTitle = GlobalData.factorArray[(indexPath?.row)!].info_title_fr
            nextViewController.strInfo = GlobalData.factorArray[(indexPath?.row)!].info_fr
            nextViewController.strEx = GlobalData.factorArray[(indexPath?.row)!].example_fr
            nextViewController.strLegal = GlobalData.factorArray[(indexPath?.row)!].legal_fr
        } else {
            nextViewController.strTitle = GlobalData.factorArray[(indexPath?.row)!].info_title
            nextViewController.strInfo = GlobalData.factorArray[(indexPath?.row)!].info
            nextViewController.strEx = GlobalData.factorArray[(indexPath?.row)!].example
            nextViewController.strLegal = GlobalData.factorArray[(indexPath?.row)!].legal
        }
        nextViewController.strIcon = GlobalData.factorArray[(indexPath?.row)!].icon_info_img
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
}
