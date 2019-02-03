//
//  RecordSoundViewController.swift
//  pichperfect
//
//  Created by samar on 19/02/1440 AH.
//  Copyright © 1440 udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController , AVAudioRecorderDelegate{
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordinglabel: UILabel!
    @IBOutlet weak var recordbutton: UIButton!
    @IBOutlet weak var stoprecordingbutton: UIButton!
    
    // to configure the UI for the Record sound view
    func configureUI(isRecording:Bool)
    {
        recordinglabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
        stoprecordingbutton.isEnabled = isRecording
        recordbutton.isEnabled = !isRecording
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        stoprecordingbutton.isEnabled=false
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
    
    }
    
    
    

    @IBAction func recordAudio(_ sender: AnyObject) {
        
        
        configureUI(isRecording:true)
    
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
       
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode:.default, options:.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
  }
    
    @IBAction func stoprecord(_ sender: AnyObject) {
        
        configureUI(isRecording:false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
   }
   
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecorder", sender: audioRecorder.url)
        } else {
            print("recourding was not successful")
        }
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecorder" {
            let playSoundsVS = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVS.recordedAudioURL = recordedAudioURL
        }
    }
}


