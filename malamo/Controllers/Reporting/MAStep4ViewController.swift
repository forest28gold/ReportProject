//
//  MAStep4ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit

class MAStep4ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var occurTableView: UITableView!
    
    var occurArray = [OccurData]()

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
        
        initOccurData()
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
    
    func initOccurData() {
        var titleArray = [NSLocalizedString("Physical location or address", comment: ""),
                          NSLocalizedString("This happened in transportation", comment: ""),
                          NSLocalizedString("This happened on the internet / social media", comment: ""),
                          NSLocalizedString("I do not want to indicate where the incondent happened", comment: "")]
        var iconImgArray = ["ic_occur_address.png", "ic_occur_transports.png", "ic_occur_internet.png", "ic_occur_unknown.png"]
        
        for i in 0...titleArray.count - 1 {
            let occurData = OccurData.init(title: titleArray[i], icon_img: iconImgArray[i], isSelected: false)
            occurArray.append(occurData)
        }

        occurTableView.reloadData()
    }
    
    //===================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //===================================
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return occurArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OccurCell", for: indexPath as IndexPath)
        
        let nameLable = cell.viewWithTag(1) as? UILabel
        let occurImage = cell.viewWithTag(2) as? UIImageView
        let backView = cell.viewWithTag(3)
        
        nameLable?.text = occurArray[indexPath.row].title
        occurImage?.image = UIImage(named: occurArray[indexPath.row].icon_img)
        
        if occurArray[indexPath.row].isSelected {
            backView?.backgroundColor = UIColor("#6a5bd0")
        } else {
            backView?.backgroundColor = UIColor("#20252b")
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        for i in 0...occurArray.count - 1 {
            if i == indexPath.row {
                occurArray[i].isSelected = true
            } else {
                occurArray[i].isSelected = false
            }
        }
        occurTableView.reloadData()
        
        GlobalData.incidentReport?.incidentOccurType = occurArray[indexPath.row].title
        
        if indexPath.row == 0 {
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep41ViewController") as! MAStep41ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else if indexPath.row == 1 {
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep42ViewController") as! MAStep42ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else if indexPath.row == 2 {
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep43ViewController") as! MAStep43ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep5ViewController") as! MAStep5ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
