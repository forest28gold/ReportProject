//
//  MAWebViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import SwiftWebViewProgress

class MAWebViewController: UIViewController, UIWebViewDelegate, WebViewProgressDelegate {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleView: UIView!
    @IBOutlet var progressView: WebViewProgressView!
    @IBOutlet var mainView: UIView!
    var strTitle: String = ""
    var strLink: String = ""
    
    private var webView: UIWebView!
    private var progressProxy: WebViewProgress!

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
        
        titleLabel.text = strTitle
        
        webView = UIWebView(frame: self.mainView.bounds)
        webView.backgroundColor = UIColor("#ffffff")
        self.mainView.addSubview(webView)
        
        progressProxy = WebViewProgress()
        webView.delegate = progressProxy
        progressProxy.webViewProxyDelegate = self
        progressProxy.progressDelegate = self
        
        loadWebPage(strLink)
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private Method
    fileprivate func loadWebPage(_ strUrl: String) {
        let request = URLRequest(url: URL(string: strUrl)!)
//        let request = URLRequest(url: URL(string: "http://apple.com")!)
        webView.loadRequest(request)
    }
    
    // MARK: - WebViewProgressDelegate
    func webViewProgress(_ webViewProgress: WebViewProgress, updateProgress progress: Float) {
        progressView.setProgress(progress, animated: true)
    }

}
