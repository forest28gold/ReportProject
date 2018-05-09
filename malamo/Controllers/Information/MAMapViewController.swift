//
//  MAMapViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD

class MAMapViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, GMSAutocompleteFetcherDelegate, CLLocationManagerDelegate, ShowsAlert {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    @IBOutlet weak var mapBottomMargin: NSLayoutConstraint!
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var resultView: UIView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var searchTableView: UITableView!
    
    @IBOutlet var infoWinView: UIView!
    @IBOutlet var infoWinButton: UIButton!
    @IBOutlet var infoTitleLabel: UILabel!
    @IBOutlet var pinView: UIImageView!
    
    var resultsPrimaryArray = [String]()
    var resultsSecondaryArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var locationManager: CLLocationManager!
    
    var myLatitude: Double = 0.0
    var myLongitude: Double = 0.0
    var mlatitude: Double = 0.0
    var mlongitude: Double = 0.0
    var mAddress = ""
    
    var isInfoWin = false
    var isSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                navHeight.constant += 25
                btnLeftMargin.constant += CGFloat(BUTTON_MARGIN)
                btnRightMargin.constant += CGFloat(BUTTON_MARGIN)
                mapBottomMargin.constant += CGFloat(BUTTON_MARGIN)
                saveButton.layer.cornerRadius = CGFloat(BUTTON_RADIUS)
                self.view.layoutIfNeeded()
                print("iPhone X")
                break
            default:
                print("iPhone")
                break
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        self.pinView.isUserInteractionEnabled = true
        self.pinView.addGestureRecognizer(tap)
        
        searchView.layer.cornerRadius = 6.0
        infoWinView.isHidden = true
        isInfoWin = false
        isSearched = false
        
        let camera = GMSCameraPosition.camera(withLatitude: Constants.LAT_MONTREAL, longitude: Constants.LNG_MONTREAL, zoom: Float(Constants.MAP_ZOOM))
        mapView.animate(to: camera)
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            mapView.isMyLocationEnabled = true
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.country = "CA"
        if GlobalData.isCity {
            searchTextField.placeholder = NSLocalizedString("Search for a city", comment: "")
            filter.type = .city
        } else {
            searchTextField.placeholder = NSLocalizedString("Search for an address", comment: "")
        }
        gmsFetcher.autocompleteFilter = filter
        
        let startLocation = CLLocationCoordinate2D(latitude: 51.549887, longitude: -79.551590)
        let fromLocation = CLLocationCoordinate2D(latitude: 51.998344, longitude: -57.108127)
        let bounds = GMSCoordinateBounds(coordinate: startLocation, coordinate: fromLocation)
        gmsFetcher.autocompleteBounds = bounds
        
        
        resultsPrimaryArray = [String]()
        resultsSecondaryArray = [String]()
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTableView.isHidden = true
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
    
    //================================
    
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {

    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions {
            if let prediction = prediction as GMSAutocompletePrediction! {
                self.resultsPrimaryArray.append(prediction.attributedPrimaryText.string)
                if prediction.attributedSecondaryText?.string != nil {
                    self.resultsSecondaryArray.append((prediction.attributedSecondaryText?.string)!)
                } else {
                    self.resultsSecondaryArray.append("")
                }          
                self.searchTableView.isHidden = false
            }
        }
        self.searchTableView.reloadData()
    }
    
    //=================================
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            self.dismissKeyboard()
            self.searchTextField.text = title

            self.isSearched = true
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: Float(Constants.MAP_SEARCH_ZOOM))
            self.mapView.animate(to: camera)
            
            self.infoTitleLabel.text = title
            self.mAddress = title
        }
    }
    
    //=================================
    
    @objc func handleTapFrom(recognizer : UITapGestureRecognizer) {
        if isInfoWin {
            isInfoWin = false
            infoWinView.isHidden = true
        } else {
            if self.infoTitleLabel.text == "" {
                SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
                DispatchQueue.main.async { () -> Void in
                    self.getAddressForLatLng(latitude: String(self.mlatitude), longitude: String(self.mlongitude))
                }
            } else {
                isInfoWin = true
                infoWinView.isHidden = false
            }
        }
    }
    
    @IBAction func infoWinButtonPressed(_ sender: Any) {
        resourceAction(lat: self.mlatitude, lng: self.mlongitude)
    }

    func getAddressForLatLng(latitude: String, longitude: String) {
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&sensor=true_or_false&language=\(GlobalData.currentLocale)")
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray {
                
                SVProgressHUD.dismiss()
                
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as? NSDictionary {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            var number = ""
                            var street = ""
                            var city = ""
                            var state = ""
                            var zip = ""
                            
                            if(address.count > 1) {
                                number =  (address.object(at: 0) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 2) {
                                street = (address.object(at: 1) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 3) {
                                city = (address.object(at: 2) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 4) {
                                state = (address.object(at: 4) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 6) {
                                zip = (address.object(at: 6) as! NSDictionary)["short_name"] as! String
                            }
                            
//                            newaddress = "\(number) \(street), \(city), \(state) \(zip)"
                            newaddress = "\(number) \(street), \(city), \(state) \(zip)"
                            
                            if GlobalData.isCity {
                                newaddress = city
                            }
                            
                            mAddress = newaddress
                            self.infoTitleLabel.text = mAddress
                            
                            isInfoWin = true
                            infoWinView.isHidden = false
                            
                            print("address : " + mAddress)
                            
                            return
                        }
                    }
                }
                mAddress = ""
                self.infoTitleLabel.text = ""
                
                self.showAlert(message: NSLocalizedString("The current address is invalid. Please tap pin again.", comment: ""))
                return
                
            } else {
                SVProgressHUD.dismiss()
                
                mAddress = ""
                self.infoTitleLabel.text = ""
                
                self.showAlert(message: NSLocalizedString("The current address is invalid. Please tap pin again.", comment: ""))
                return
            }
        } else {
            SVProgressHUD.dismiss()
            
            mAddress = ""
            self.infoTitleLabel.text = ""

            self.showAlert(message: NSLocalizedString("The current address is invalid. Please tap pin again.", comment: ""))
            return
        }
    }
    
    //=================================
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isSearched {
            isSearched = false
        } else {
            self.infoTitleLabel.text = ""
            mAddress = ""
        }
        self.mlatitude = position.target.latitude
        self.mlongitude = position.target.longitude
        print("Latitude = " + String(self.mlatitude))
        print("Longitude = " + String(self.mlongitude))
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        isInfoWin = false
        infoWinView.isHidden = true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        isInfoWin = false
        infoWinView.isHidden = true
    }
    
    //===================================
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            searchTableView.isHidden = true
        } else {
            self.resultsPrimaryArray.removeAll()
            self.resultsSecondaryArray.removeAll()
            gmsFetcher?.sourceTextHasChanged(textField.text)
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //===================================
    
    func resourceAction(lat: Double, lng: Double) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open in Google Map", comment: ""), style: .default , handler:{ (UIAlertAction)in
            // Open and show coordinate
            let strLat : String = String(lat)
            let strLong : String = String(lng)
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=&daddr=\(strLat),\(strLong)&directionsmode=driving")!)
            } else {
                let url = "http://maps.apple.com/maps?saddr=&daddr=\(strLat),\(strLong)"
                UIApplication.shared.openURL(URL(string:url)!)
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    //===================================
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsPrimaryArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath as IndexPath)
        
        let primaryLable = cell.viewWithTag(1) as? UILabel
        let secondaryLable = cell.viewWithTag(2) as? UILabel
        primaryLable?.text = resultsPrimaryArray[indexPath.row]
        secondaryLable?.text = resultsSecondaryArray[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        searchTableView.isHidden = true
        dismissKeyboard()
        
        var strSearch = resultsPrimaryArray[indexPath.row] + ", " + resultsSecondaryArray[indexPath.row]
        
        if resultsSecondaryArray[indexPath.row] == "" {
            strSearch = resultsPrimaryArray[indexPath.row]
        }
        
        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(strSearch)&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlpath!)
        // print(url!)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            // 3
            do {
                if data != nil {
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    let geoArray = dic.value(forKey: "results") as! NSArray
                    if geoArray.count > 0 {
                        let lat = (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
                        
                        let lon = (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
                        if lat != 0 && lon != 0 {
                            // 4
                            if GlobalData.isCity {
                                strSearch = self.resultsPrimaryArray[indexPath.row]
                            }
                            self.locateWithLongitude(lon, andLatitude: lat, andTitle: strSearch)
                        }
                    }
                }
            } catch {
                print("Error")
            }
        }
        // 5
        task.resume()
    }
    
    //===================================
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        GlobalData.isLocation = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        locationManager = CLLocationManager()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            mapView.isMyLocationEnabled = true
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            let camera = GMSCameraPosition.camera(withLatitude: myLatitude, longitude: myLongitude, zoom: Float(Constants.MAP_SEARCH_ZOOM))
            mapView.animate(to: camera)
            mAddress = ""
            infoWinView.isHidden = true
            isInfoWin = false
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        GlobalData.isLocation = true
        if mAddress == "" || mlongitude == 0.0 || mlatitude == 0.0 {
            self.showAlert(message: NSLocalizedString("The current address is invalid. Please tap pin again.", comment: ""))
            return
        }
        
        GlobalData.incidentAddress = mAddress
        GlobalData.incidentLatitude = mlatitude
        GlobalData.incidentLongitude = mlongitude
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //================================
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" + error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        myLatitude = userLocation!.coordinate.latitude
        myLongitude = userLocation!.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
    }
    
}
