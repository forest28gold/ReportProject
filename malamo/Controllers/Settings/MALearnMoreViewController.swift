//
//  MALearnMoreViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MALearnMoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var learnMoreTableView: UITableView!
    
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
        
        initLoadKnowMoreData()
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
    
    func initLoadKnowMoreData() {
        if GlobalData.knowMoreArray.count > 0 {
            
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_KNOW_MORE)
            query.order(byAscending: "order")
            query.findObjectsInBackground (block: { (objects, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let title = GlobalData.onCheckStringNull(object: object, key: "title")
                            let title_fr = GlobalData.onCheckStringNull(object: object, key: "title_fr")
                            let weblink = GlobalData.onCheckStringNull(object: object, key: "weblink")
                            let knowMoreData = KnowMoreData.init(title: title, title_fr: title_fr, weblink: weblink)
                            GlobalData.knowMoreArray.append(knowMoreData)
                        }
                        self.learnMoreTableView.reloadData()
                    }
                } else {
                    
                }
            })
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //===================================

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.knowMoreArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LearnMoreCell", for: indexPath as IndexPath)
        
        let nameLable = cell.viewWithTag(1) as? UILabel
        
        var title = ""
        
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            title = GlobalData.knowMoreArray[indexPath.row].title_fr
        } else {
            title = GlobalData.knowMoreArray[indexPath.row].title
        }
        
        let attributedString = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        nameLable?.attributedText = attributedString;
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAWebViewController") as! MAWebViewController
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            nextViewController.strTitle = GlobalData.knowMoreArray[indexPath.row].title_fr
            nextViewController.strLink = GlobalData.knowMoreArray[indexPath.row].weblink
        } else {
            nextViewController.strTitle = GlobalData.knowMoreArray[indexPath.row].title
            nextViewController.strLink = GlobalData.knowMoreArray[indexPath.row].weblink
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
