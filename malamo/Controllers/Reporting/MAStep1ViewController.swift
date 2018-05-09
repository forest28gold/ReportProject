//
//  MAStep1ViewController.swift
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

class MAStep1ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ShowsAlert {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
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

        loadIncidentKindData()
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
    
    func loadIncidentKindData() {
        
        if GlobalData.categoryArray.count > 0 {
            for i in 0...GlobalData.categoryArray.count - 1 {
                if GlobalData.categoryArray[i].isSelected {
                    GlobalData.categoryArray[i].isSelected = false
                }
            }
            self.categoryCollectionView.reloadData()
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_INCIDENT_KIND)
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
                            GlobalData.categoryArray.append(factorData)
                        }
                        self.categoryCollectionView.reloadData()
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
        
        GlobalData.incidentKindIds = [String]()
        var selectedCount = 0
        
        for factor in GlobalData.categoryArray {
            if factor.isSelected {
                if GlobalData.currentLocale == Constants.LOCALE_FR {
                    GlobalData.incidentKindIds.append(factor.name_fr)
                } else {
                    GlobalData.incidentKindIds.append(factor.name)
                }
                selectedCount = selectedCount + 1
            }
        }
        
        if selectedCount == 0 {
            self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
            return
        }
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep2ViewController") as! MAStep2ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //===================================
    
    // MARK: - UICollectionViewDataSource protocol
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalData.categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 3 - 0.8, height: self.view.frame.width / 3 - 0.8)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath)
        
        let nameLable = cell.viewWithTag(1) as? UILabel
        let categoryImage = cell.viewWithTag(2) as? UIImageView
        let infoButton = cell.viewWithTag(3) as? UIButton
        let backView = cell.viewWithTag(4)
        
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            nameLable?.text = GlobalData.categoryArray[indexPath.row].name_fr
        } else {
            nameLable?.text = GlobalData.categoryArray[indexPath.row].name
        }
        
        categoryImage?.sd_setImage(with: URL(string: GlobalData.categoryArray[indexPath.row].icon_img), placeholderImage: UIImage(named: "ic_placeholder"))
        infoButton?.addTarget(self, action: #selector(self.infoButtonClicked), for: .touchUpInside)
        
        if GlobalData.categoryArray[indexPath.row].isSelected {
            backView?.backgroundColor = UIColor("#6a5bd0")
        } else {
            backView?.backgroundColor = UIColor("#20252b")
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        if GlobalData.categoryArray[indexPath.row].isSelected {
            GlobalData.categoryArray[indexPath.row].isSelected = false
        } else {
            GlobalData.categoryArray[indexPath.row].isSelected = true
        }
        categoryCollectionView.reloadData()
    }
    
    @objc func infoButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: categoryCollectionView)
        var indexPath: IndexPath? = categoryCollectionView.indexPathForItem(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAInformationViewController") as! MAInformationViewController
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            nextViewController.strTitle = GlobalData.categoryArray[(indexPath?.row)!].info_title_fr
            nextViewController.strInfo = GlobalData.categoryArray[(indexPath?.row)!].info_fr
            nextViewController.strEx = GlobalData.categoryArray[(indexPath?.row)!].example_fr
            nextViewController.strLegal = GlobalData.categoryArray[(indexPath?.row)!].legal_fr
        } else {
            nextViewController.strTitle = GlobalData.categoryArray[(indexPath?.row)!].info_title
            nextViewController.strInfo = GlobalData.categoryArray[(indexPath?.row)!].info
            nextViewController.strEx = GlobalData.categoryArray[(indexPath?.row)!].example
            nextViewController.strLegal = GlobalData.categoryArray[(indexPath?.row)!].legal
        }
        nextViewController.strIcon = GlobalData.categoryArray[(indexPath?.row)!].icon_info_img
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
}
