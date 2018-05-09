//
//  MASplashViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 2/20/18.
//  Copyright © 2018 AppsCreationTech. All rights reserved.
//

import UIKit
import Foundation

class MASplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        perform(#selector(initData), with: nil, afterDelay: 1.0)
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
    
    // MARK: Data Management
    
    /// Perform initial data loading
    @objc func initData() {
        DispatchQueue.main.async { () -> Void in
            
            // Do your loading stuff here and throw an error if needed
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: "welcome") {
                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAHomeViewController") as! MAHomeViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
            } else {
                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAWelcomeViewController") as! MAWelcomeViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }

}
