//
//  MAFAQViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MAFAQViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
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
        
        loadFAQData()
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
    
    func loadFAQData() {
        
        if GlobalData.faqArray.count > 0 {
            
        } else {
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
            
            let query = PFQuery(className: Constants.CLASS_FAQ)
            query.order(byAscending: "order")
            query.findObjectsInBackground (block: { (objects, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            let question = GlobalData.onCheckStringNull(object: object, key: "question")
                            let answer = GlobalData.onCheckStringNull(object: object, key: "answer")
                            let question_fr = GlobalData.onCheckStringNull(object: object, key: "question_fr")
                            let answer_fr = GlobalData.onCheckStringNull(object: object, key: "answer_fr")
                            let faqData = FAQData.init(question: question, answer: answer, question_fr: question_fr, answer_fr: answer_fr)
                            GlobalData.faqArray.append(faqData)
                        }
                        self.tableView.reloadData()
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
        return GlobalData.faqArray.count
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath as IndexPath)
        
        let questionLable = cell.viewWithTag(1) as? UILabel
        let answerLable = cell.viewWithTag(2) as? UILabel
        
        if GlobalData.currentLocale == Constants.LOCALE_FR {
            
            let attributedString = NSMutableAttributedString(string: GlobalData.faqArray[indexPath.row].question_fr)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            questionLable?.attributedText = attributedString;
            
            let attributedAnswerString = NSMutableAttributedString(string: GlobalData.faqArray[indexPath.row].answer_fr)
            let paragraphAnswerStyle = NSMutableParagraphStyle()
            paragraphAnswerStyle.lineSpacing = 4
            attributedAnswerString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphAnswerStyle, range:NSMakeRange(0, attributedAnswerString.length))
            answerLable?.attributedText = attributedAnswerString;
            
        } else {
         
            let attributedString = NSMutableAttributedString(string: GlobalData.faqArray[indexPath.row].question)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            questionLable?.attributedText = attributedString;
            
            let attributedAnswerString = NSMutableAttributedString(string: GlobalData.faqArray[indexPath.row].answer)
            let paragraphAnswerStyle = NSMutableParagraphStyle()
            paragraphAnswerStyle.lineSpacing = 4
            attributedAnswerString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphAnswerStyle, range:NSMakeRange(0, attributedAnswerString.length))
            answerLable?.attributedText = attributedAnswerString;
        }
        
        return cell
    }

}
