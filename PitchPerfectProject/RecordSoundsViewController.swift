//
//  RecordSoundsViewController.swift
//  PitchPerfectProject
//
//  Created by Pedro Ullmann on 9/1/18.
//  Copyright © 2018 Pedro Ullmann. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    //MARK: Variables
    var audioRecorder: AVAudioRecorder!
    let stopRecordingIdentifier: String = "goToStopRecording"
    
    //MARK: Outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(false)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == stopRecordingIdentifier {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    @IBAction func unwindToRecordSounds(segue:UIStoryboardSegue) {
        //I can pass some data between viewControllers...
    }
    
    //MARK: Actions
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //MARK: Configure the UIElements
    func configureUI(_ enabled: Bool) {
        let recordingText = enabled ? "Recording in Progress" : "Tap to Record"
        recordingLabel.text = recordingText
        recordButton.isEnabled = !enabled
        stopRecordingButton.isEnabled = enabled
    }
}


//MARK: AVAudioRecorderDelegate
extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: stopRecordingIdentifier, sender: audioRecorder.url)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Recording was not successful", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            
            //Adding the action
            alertController.addAction(defaultAction)
            
            //Presenting alert
            present(alertController, animated: true, completion: nil)
        }
    }
}
