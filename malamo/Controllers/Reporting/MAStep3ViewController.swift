//
//  MAStep3ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/13/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AssetsLibrary

class MAStep3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ShowsAlert {

    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var btnRightMargin: NSLayoutConstraint!
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var factCollectionView: UICollectionView!
    @IBOutlet var linkTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var pickerController = UIImagePickerController()
    var imageView = UIImage()
    var videoURL : NSURL?

    var strType = "photo"
    
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
        
        GlobalData.incidentDescription = ""
        
        GlobalData.mediaArray = [MediaData]()
        GlobalData.linkArray = [String]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionLabel.text = GlobalData.incidentDescription
        
        if GlobalData.isRecord {
            GlobalData.isRecord = false
            
            imageView = UIImage(named: "ic_wave")!
            let mediaData = MediaData.init(type: "audio", photo: imageView, path: GlobalData.audioFilePath)
            GlobalData.mediaArray.append(mediaData)
            factCollectionView.reloadData()

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
    
    func openPhotoCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerControllerSourceType.camera
            pickerController.mediaTypes = [kUTTypeImage as String]
            pickerController.allowsEditing = false
            self .present(self.pickerController, animated: true, completion: nil)
        } else {
            let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("You don't have a camera.", comment: ""), preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.mediaTypes = [kUTTypeImage as String]
            pickerController.allowsEditing = false
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func openVideoCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerControllerSourceType.camera
            pickerController.mediaTypes = [kUTTypeMovie as String]
            pickerController.allowsEditing = false
            self .present(self.pickerController, animated: true, completion: nil)
        } else {
            let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("You don't have a camera.", comment: ""), preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func openVideoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.mediaTypes = [kUTTypeMovie as String]
            pickerController.allowsEditing = false
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //-------------------------------------
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if strType == "photo" {
            imageView = info[UIImagePickerControllerOriginalImage] as! UIImage
            let mediaData = MediaData.init(type: "photo", photo: imageView, path: "")
            GlobalData.mediaArray.append(mediaData)
            factCollectionView.reloadData()
        } else {
            videoURL = info[UIImagePickerControllerMediaURL] as? NSURL
            print(videoURL!)
            
            if isEnabeUploadData((videoURL?.path)!) {
                do {
                    let asset = AVURLAsset(url: videoURL! as URL , options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    imageView = thumbnail
                    let mediaData = MediaData.init(type: "video", photo: imageView, path: (videoURL?.path)!)
                    GlobalData.mediaArray.append(mediaData)
                    factCollectionView.reloadData()
                } catch {
                    imageView = UIImage(named: "ic_gradient")!
                    let mediaData = MediaData.init(type: "video", photo: imageView, path: (videoURL?.path)!)
                    GlobalData.mediaArray.append(mediaData)
                    factCollectionView.reloadData()
                }
                
            } else {
                self.showAlert(message: NSLocalizedString("You can upload video file less than 10MB.", comment: ""))
                return
            }
        }
        
        dismiss(animated:true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    //========================================
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func descriptionButtonPressed(_ sender: Any) {
        GlobalData.isDescrition = true
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MADetailsViewController") as! MADetailsViewController
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func photoButtonPressed(_ sender: Any) {
        
        strType = "photo"
        
        let alert = UIAlertController(title: NSLocalizedString("Choose from...", comment: ""), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default , handler:{ (UIAlertAction)in
            self.openPhotoCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default , handler:{ (UIAlertAction)in
            self.openPhotoLibrary()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func videoButtonPressed(_ sender: Any) {
        
        strType = "video"
        
        let alert = UIAlertController(title: NSLocalizedString("Choose from...", comment: ""), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default , handler:{ (UIAlertAction)in
            self.openVideoCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Video Library", comment: ""), style: .default , handler:{ (UIAlertAction)in
            self.openVideoLibrary()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func audioButtonPressed(_ sender: Any) {
        GlobalData.isRecord = false
        GlobalData.audioFilePath = ""
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAAudioRecordViewController") as! MAAudioRecordViewController
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func webLinkButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Web link", comment: ""), message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {
            alert -> Void in
            
            let linkTextField = alertController.textFields![0] as UITextField
            if linkTextField.text != "" || linkTextField.text != "https://" {
                GlobalData.linkArray.append(linkTextField.text!)
                self.linkTableView.reloadData()
            } else {
                // Show Alert Message to User As per you want
                
                let errorAlert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please input web link.", comment: ""), preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        // add the textField
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.textAlignment = .left
            textField.font = UIFont.systemFont(ofSize: 13)
            textField.returnKeyType = UIReturnKeyType.done
            textField.autocapitalizationType = .none
            textField.keyboardType = .URL
            textField.text = "https://"
        }
        // add the actions (buttons)
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        // show the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if GlobalData.incidentDescription == "" && GlobalData.mediaArray.count == 0 && GlobalData.linkArray.count == 0 {
            self.showAlert(message: NSLocalizedString("Some information is missing. Please follow instructions to be able to continue.", comment: ""))
            return
        }
        
        GlobalData.incidentReport?.incidentDescripion = GlobalData.incidentDescription
 
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MAStep4ViewController") as! MAStep4ViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //===================================
    
    func removeRecordFile(_ filePath: String) {
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: filePath) {
                try fileManager.removeItem(atPath: filePath)
                print("Successfully removed")
            } else {
                print("File does not exist")
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func isEnabeUploadData(_ filePath: String) -> Bool {
        var fileSize = 0
        if  FileManager.default.fileExists(atPath: filePath) {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
                fileSize = attributes[FileAttributeKey.size] as? Int ?? 0
                print("file size :  \(fileSize) bytes")
                
                if fileSize >= 10485760 || fileSize == 0 {
                    return false
                } else {
                    return true
                }
            } catch let e {
                print("Can not read attributes for this file", e)
            }
        } else {
            print("This file doesn't exist")
        }
        return false
    }
    
    //===================================
    
    // MARK: - UICollectionViewDataSource protocol
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalData.mediaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.factCollectionView.frame.width / 3 - 0.8, height: self.factCollectionView.frame.width / 3 - 0.8)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FactCell", for: indexPath as IndexPath)
        
        let typeImage = cell.viewWithTag(1) as? UIImageView
        let sourceImage = cell.viewWithTag(2) as? UIImageView
        let deleteButton = cell.viewWithTag(3) as? UIButton
        
        if GlobalData.mediaArray[indexPath.row].type == "photo" {
            typeImage?.image = UIImage(named: "ic_photo")
            sourceImage?.image = GlobalData.mediaArray[indexPath.row].photo
        } else if GlobalData.mediaArray[indexPath.row].type == "video" {
            typeImage?.image = UIImage(named: "ic_video")
            sourceImage?.image = GlobalData.mediaArray[indexPath.row].photo
        } else {
            typeImage?.image = UIImage(named: "ic_audio")
            sourceImage?.image = UIImage(named: "ic_wave")
        }
        
        deleteButton?.addTarget(self, action: #selector(self.deleteMediaButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
    }
    
    @objc func deleteMediaButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: factCollectionView)
        var indexPath: IndexPath? = factCollectionView.indexPathForItem(at: buttonFrameInTableView?.origin ?? CGPoint.zero)
        
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("You are about to delete this file.", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: UIAlertActionStyle.default, handler: { action in
            
            if GlobalData.mediaArray[(indexPath?.row)!].type == "audio" {
                self.removeRecordFile(GlobalData.mediaArray[(indexPath?.row)!].path)
            }
            
            GlobalData.mediaArray.remove(at: (indexPath?.row)!)
            self.factCollectionView.reloadData()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //===================================

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.linkArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath as IndexPath)
        
        let linkLable = cell.viewWithTag(1) as? UILabel
        let deleteButton = cell.viewWithTag(2) as? UIButton
        
        linkLable?.text = GlobalData.linkArray[indexPath.row]
        deleteButton?.addTarget(self, action: #selector(self.deleteButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    @objc func deleteButtonClicked(_ sender: Any) {
        let btn = sender as? UIButton
        let buttonFrameInTableView: CGRect? = btn?.convert(btn?.bounds ?? CGRect.zero, to: linkTableView)
        var indexPath: IndexPath? = linkTableView.indexPathForRow(at: buttonFrameInTableView?.origin ?? CGPoint.zero)

        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("You are about to delete this web link.", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: UIAlertActionStyle.default, handler: { action in
            
            GlobalData.linkArray.remove(at: (indexPath?.row)!)
            self.linkTableView.reloadData()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
