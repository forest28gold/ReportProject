//
//  MAAudioRecordViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 1/9/18.
//  Copyright © 2018 AppsCreationTech. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class MAAudioRecordViewController: UIViewController, AVAudioPlayerDelegate, ShowsAlert {
    
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var tapLabel: UILabel!
    @IBOutlet weak var audioPlot: SoundWaveVisualizer!
    @IBOutlet weak var playButton: UIButton!
    
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    var displaylink: CADisplayLink!
    
    var recordUrl: URL!
    var timer: Timer!
    var strRecordDate: String!
    var is_record = false
    var is_timeout = false
    var recordCount = 0
    
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
        
        audioPlot.backgroundColor = UIColor.clear
        
        is_record = false
        tapLabel.isHidden = false
        saveButton.isHidden = true
        playButton.isHidden = true
        recordButton.setImage(UIImage(named: "ic_record"), for: .normal)
        playButton.setImage(UIImage(named: "ic_play_btn"), for: .normal)
        
        setupAudioSession()
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
        removeRecordFile(recordUrl.path)
        GlobalData.isRecord = false
        GlobalData.audioFilePath = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        GlobalData.isRecord = true
        GlobalData.audioFilePath = recordUrl.path
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        is_record = false
        if (player?.isPlaying)! {
            player?.pause()
            playButton.setImage(UIImage(named: "ic_play_btn"), for: .normal)
        } else {
            player?.play()
            playButton.setImage(UIImage(named: "ic_pause_btn"), for: .normal)
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if is_record {
            print("Record end...")
            is_record = false
            stopRecord()
        } else {
            print("Record start...")
            is_record = true
            is_timeout = false
            startRecord()
        }
    }

    //========================

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

    var audioFileUrl: URL {
        
        let random = GlobalData.randomNumber(length: Constants.RECORD_NUMBER_LIMIT)
        let fileName = random + Constants.RECORD_FILE_FORMAT
        
        let url = FileManager.fileUrlInsideCacheDir(fileName)
        return url
    }

    fileprivate func setupAudioSession() {

        let recoderSettings: [String: AnyObject] = [
            AVSampleRateKey:          44100.0 as AnyObject,
            AVFormatIDKey:            NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
            AVNumberOfChannelsKey:    2 as AnyObject,
            AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32)
        ]

        let session = AVAudioSession.sharedInstance()

        session.requestRecordPermission {[weak self] granted in
            guard self != nil else { return }

            if !granted {
                self?.showAlert(message: NSLocalizedString("Enable microphone access\nfrom system preferences", comment: ""))
                self?.recordButton.isEnabled = false
            } else {
                self?.recordButton.isEnabled = true
            }
        }

        do {
            
            recordUrl = audioFileUrl
            
            FileManager.default.createFile(atPath: recordUrl.path, contents: nil, attributes: nil)

            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            try session.overrideOutputAudioPort(.speaker)

            recorder = try AVAudioRecorder(url: recordUrl, settings: recoderSettings)

            displaylink = CADisplayLink(target: self, selector: #selector(updateMeters))
            displaylink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)

        } catch let e {
            print("VoiceRecordView: setup AVAudioSession error", e)
        }
    }

    func startRecord() {
        player?.stop()
        
        recordCount = 0;
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)

        timeLabel.text = "00:00 / 01:00"
        tapLabel.isHidden = true
        saveButton.isHidden = true
        playButton.isHidden = true
        recordButton.setImage(UIImage(named: "ic_record_stop"), for: .normal)

        recorder?.stop()
        recorder?.prepareToRecord()
        recorder?.isMeteringEnabled = true
        recorder?.record()
    }

    func stopRecord() {
        let recordTime = recorder?.currentTime ?? 0.0
        
        timer.invalidate()
        recorder?.stop()
        
        if recordTime > 1 || is_timeout {
            tapLabel.isHidden = false
            saveButton.isHidden = false
            playButton.isHidden = true
            recordButton.setImage(UIImage(named: "ic_record"), for: .normal)
            
            do {
                player = try AVAudioPlayer(contentsOf: recordUrl)
                player?.delegate = self
                player?.isMeteringEnabled = true
                player?.prepareToPlay()
            } catch let e {
                print("VoiceRecordView: create AVAudioPlayer error", e)
            }
            
        } else {
            tapLabel.isHidden = false
            saveButton.isHidden = true
            playButton.isHidden = true
            recordButton.setImage(UIImage(named: "ic_record"), for: .normal)
        }
    }
    
    @objc func updateTime() {
        recordCount += 1

        if recordCount == 60 {
            timeLabel.text = "01:00 / 01:00"
            is_record = false
            is_timeout = true
            stopRecord()
        } else {
            timeLabel.text = String(format: "00:%02d / 01:00", recordCount)
        }
    }

    //===================================
    
    func normalizedPower(_ decibels: Float) -> Float {
        if (decibels < -60.0 || decibels == 0.0) {
            return 0.0
        }
        return powf((pow(10.0, 0.05 * decibels) - pow(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - pow(10.0, 0.05 * -60.0))), 1.0 / 2.0)
    }

    @objc func updateMeters() {
        var normalizedValue: Float = 0.0
        
        if is_record {
            if let recorder = recorder {
                recorder.updateMeters()
                let decibels = recorder.averagePower(forChannel: 0)
                print("Recording Amplitude ======   " + String(decibels))
                normalizedValue = normalizedPower(decibels)
                print("Normalized Amplitude :   " + String(normalizedValue))
            }
        } else {
            if let player = player {
                player.updateMeters()
                let decibels = player.averagePower(forChannel: 0)
                normalizedValue = normalizedPower(decibels)
            }
        }
        
        audioPlot.updateWithPowerLevel(normalizedValue)
    }
    
    //===================================
    
    // MARK: - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setImage(UIImage(named: "ic_play_btn"), for: .normal)
        player.currentTime = 0
        player.prepareToPlay()
    }
}
