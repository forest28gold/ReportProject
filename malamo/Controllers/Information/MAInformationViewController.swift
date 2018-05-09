//
//  MAInformationViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit

class MAInformationViewController: UIViewController {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var exampleLabel: UILabel!
    @IBOutlet var nbLabel: UILabel!
    @IBOutlet var exampleView: UIView!
    
    var strIcon = ""
    var strTitle = ""
    var strInfo = ""
    var strEx = ""
    var strLegal = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                navHeight.constant += 25
                btnLeftMargin.constant += CGFloat(BUTTON_MARGIN)
                btnRightMargin.constant += CGFloat(BUTTON_MARGIN)
                closeButton.layer.cornerRadius = CGFloat(BUTTON_RADIUS)
                self.view.layoutIfNeeded()
                print("iPhone X")
                break
            default:
                print("iPhone")
                break
            }
        }

        iconImageView?.sd_setImage(with: URL(string: strIcon), placeholderImage: UIImage(named: "ic_placeholder_dark"))
        
        if strEx == "" {
            exampleView.isHidden = true
        }
        
        if strLegal == "" {
            nbLabel.isHidden = true
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attributedString = NSMutableAttributedString(string: strTitle)
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        titleLabel?.attributedText = attributedString;
        
        let attributedInfoString = NSMutableAttributedString(string: strInfo)
        attributedInfoString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedInfoString.length))
        infoLabel?.attributedText = attributedInfoString;
        
        let attributedExString = NSMutableAttributedString(string: strEx)
        attributedExString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedExString.length))
        exampleLabel?.attributedText = attributedExString;
        
        let attributedLegalString = NSMutableAttributedString(string: strLegal)
        attributedLegalString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedLegalString.length))
        nbLabel?.attributedText = attributedLegalString;
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
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
