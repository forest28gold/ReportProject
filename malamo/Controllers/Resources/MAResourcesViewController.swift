//
//  MAResourcesViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Parse
import SVProgressHUD

class MAResourcesViewController: UIViewController, UIActionSheetDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, GMSAutocompleteFetcherDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var resultView: UIView!
    @IBOutlet var searchTableView: UITableView!

    var resultsPrimaryArray = [String]()
    var resultsSecondaryArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var locationManager: CLLocationManager!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0

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
        
        GlobalData.organismIdsArray = [String]()
        GlobalData.organismArray = [OrganismData]()
        GlobalData.isSeeAll = true
        
        searchView.layer.cornerRadius = 6.0

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
        gmsFetcher.autocompleteFilter = filter
        
        let startLocation = CLLocationCoordinate2D(latitude: 51.549887, longitude: -79.551590)
        let fromLocation = CLLocationCoordinate2D(latitude: 51.998344, longitude: -57.108127)
        let bounds = GMSCoordinateBounds(coordinate: startLocation, coordinate: fromLocation)
        gmsFetcher.autocompleteBounds = bounds

        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.clear()
        
        if GlobalData.isSeeAll {
            for organism in GlobalData.organismArray {
                let position = CLLocationCoordinate2DMake(organism.latitude, organism.longitude)
                let marker = GMSMarker(position: position)
                marker.icon = UIImage(named: "ic_pin")
                marker.title = organism.name
                marker.snippet = organism.phoneNumber
                marker.map = self.mapView
            }
        } else {
            for organism in GlobalData.organismArray {
                for category in GlobalData.organismIdsArray {
                    if organism.categoryIds.contains(category) {
                        let position = CLLocationCoordinate2DMake(organism.latitude, organism.longitude)
                        let marker = GMSMarker(position: position)
                        marker.icon = UIImage(named: "ic_pin")
                        marker.title = organism.name
                        marker.snippet = organism.phoneNumber
                        marker.map = self.mapView
                        break
                    }
                }
            }
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
            if let prediction = prediction as GMSAutocompletePrediction!{
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
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: Float(Constants.MAP_SEARCH_ZOOM))
            self.mapView.animate(to: camera)
            
            self.getNearbyResourceData(lat: lat, lng: lon)
        }
    }
    
    func getNearbyResourceData(lat: Double, lng: Double) {
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Please wait....", comment: ""), maskType: .clear)
        
        self.mapView.clear()
        
        let searchGeoPoint = PFGeoPoint(latitude:lat, longitude:lng)
        let query = PFQuery(className: Constants.CLASS_ORGANISM)
        query.whereKey("coordinates", nearGeoPoint: searchGeoPoint, withinKilometers: Double(Constants.NEARBY_RESOURCE_DISTANCE))
        query.findObjectsInBackground (block: { (objects, error) in
            
            SVProgressHUD.dismiss()
            GlobalData.organismArray = [OrganismData]()
            
            if error == nil {
                if let objects = objects {
                    
                    var bounds = GMSCoordinateBounds()
                    
                    for object in objects {
                        let name = GlobalData.onCheckStringNull(object: object, key: "name")
                        let email = GlobalData.onCheckStringNull(object: object, key: "email")
                        let phone = GlobalData.onCheckStringNull(object: object, key: "phoneNumber")
                        let coordinate = object["coordinates"] as? PFGeoPoint
                        let categoryRelation = object.relation(forKey: "categoryIds")
                        var categoryIds = [String]()
                        categoryRelation.query().findObjectsInBackground(block: { (relations, error) in
                            if error == nil {
                                if let relations = relations {
                                    for relation in relations {
                                        categoryIds.append(relation.objectId!)
                                    }
                                    
                                    let organismData = OrganismData.init(name: name, email: email, phoneNumber: phone, latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!, categoryIds: categoryIds)
                                    GlobalData.organismArray.append(organismData)
                                    
                                    let position = CLLocationCoordinate2DMake((coordinate?.latitude)!, (coordinate?.longitude)!)
                                    let marker = GMSMarker(position: position)
                                    marker.icon = UIImage(named: "ic_pin")
                                    marker.title = name
                                    marker.snippet = phone
                                    marker.map = self.mapView
                                    
                                    bounds = bounds.includingCoordinate(marker.position)
                                    self.mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0)))
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    //=================================
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
        customInfoWindow.label.text = marker.title
        return customInfoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        resourceAction(lat: Double(marker.position.latitude), lng: Double(marker.position.longitude), phone: marker.snippet!)
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
    
    func resourceAction(lat: Double, lng: Double, phone: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Call the organization", comment: ""), style: .default , handler:{ (UIAlertAction)in
            if let url = NSURL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
        }))
        
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
        
        let strSearch = resultsPrimaryArray[indexPath.row] + ", " + resultsSecondaryArray[indexPath.row]
        
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
                        // 4
                        self.locateWithLongitude(lon, andLatitude: lat, andTitle: strSearch)
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

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAFilterViewController") as! MAFilterViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        searchTextField.text = ""
        dismissKeyboard()
        searchTableView.isHidden = true
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
            
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: Float(Constants.MAP_SEARCH_ZOOM))
            mapView.animate(to: camera)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //================================
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" + error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        latitude = userLocation!.coordinate.latitude
        longitude = userLocation!.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
    }
}
