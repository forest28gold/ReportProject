//
//  MAStep41ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import GoogleMaps

class MAStep41ViewController: UIViewController, GMSMapViewDelegate, ShowsAlert {

    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var dateView: UIView!
    @IBOutlet var datePickerView: UIDatePicker!

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
        
        dateView.isHidden = true
        datePickerView.datePickerMode = .date
        let date = NSDate()
        datePickerView.maximumDate = date as Date
        GlobalData.locationDetails = ""
        
        let camera = GMSCameraPosition.camera(withLatitude: Constants.LAT_MONTREAL, longitude: Constants.LNG_MONTREAL, zoom: Float(Constants.MAP_ZOOM))
        mapView.animate(to: camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        detailsLabel.text = GlobalData.locationDetails
        
        if GlobalData.isLocation {
            GlobalData.isLocation = false
            
            self.mapView.clear()
            
            let position = CLLocationCoordinate2DMake(GlobalData.incidentLatitude, GlobalData.incidentLongitude)
            let camera = GMSCameraPosition.camera(withLatitude: GlobalData.incidentLatitude, longitude: GlobalData.incidentLongitude, zoom: Float(Constants.MAP_ZOOM))
            self.mapView.camera = camera
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "ic_pin")
            marker.title = GlobalData.incidentAddress
            marker.map = self.mapView
        }
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
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
        customInfoWindow.label.text = marker.title
        return customInfoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        closeAnimationView(dateView)
        GlobalData.isLocation = false
        GlobalData.isCity = false
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAMapViewController") as! MAMapViewController
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    //====================================
    
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
    
    @IBAction func cancelPickerAction(_ sender: Any) {
        closeAnimationView(dateView)
    }
    
    @IBAction func donePickerAction(_ sender: Any) {
        closeAnimationView(dateView)
        
        if datePickerView.datePickerMode == .date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            dateLabel.text = formatter.string(from: datePickerView.date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timeLabel.text = formatter.string(from: datePickerView.date)
        }
    }
    
    //===================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func locationDetailsButtonPressed(_ sender: Any) {
        closeAnimationView(dateView)
        GlobalData.isDescrition = false
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MADetailsViewController") as! MADetailsViewController
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func dateButtonPressed(_ sender: Any) {
        datePickerView.datePickerMode = .date
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @IBAction func timeButtonPressed(_ sender: Any) {
        datePickerView.datePickerMode = .time
        if dateView.isHidden == true {
            showAnimationView(dateView)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let incidentDate = formatter.date(from: dateLabel.text!)
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "dd/MM/yyyy HH:mm"
        let incidentTime = formatterTime.date(from: dateLabel.text! + " " + timeLabel.text!)
        
//        if GlobalData.locationDetails == "" {
//            self.showAlert(message: NSLocalizedString("Please input location details.", comment: ""))
//            return
//        } else
        
        if dateLabel.text == NSLocalizedString("Ex : dd/mm/yyyy", comment: "") {
            self.showAlert(message: NSLocalizedString("Please input date of the incident.", comment: ""))
            return
        } else if incidentDate! > date as Date {
            self.showAlert(message: NSLocalizedString("Date of the incident is invalid.", comment: ""))
            return
        } else if timeLabel.text == NSLocalizedString("Ex : hh:mm", comment: "") {
            self.showAlert(message: NSLocalizedString("Please input time of the incident.", comment: ""))
            return
        } else if incidentTime! > date as Date {
            self.showAlert(message: NSLocalizedString("Time of the incident is invalid.", comment: ""))
            return
        }
        
        GlobalData.incidentReport?.incidentAddressDesc = GlobalData.locationDetails
        GlobalData.incidentReport?.incidentDate = dateLabel.text!
        GlobalData.incidentReport?.incidentTime = timeLabel.text!
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep5ViewController") as! MAStep5ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
