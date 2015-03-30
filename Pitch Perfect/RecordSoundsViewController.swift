//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by kabinu on 3/5/15.
//  Copyright (c) 2015 kabinu. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //declare the outlets for assets on screen
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordingText: UILabel!
    
    //declare global variables
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        
        stopButton.hidden = true;
        
     }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        recordingText.hidden = false;
        stopButton.hidden = false;
        recordButton.enabled = false
        recordLabel.hidden = true
        
        //get the current path of the application
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //use current date and time to create a unique file name
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        
        //use the filename above to record a sound file and save
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, filePathURL: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    //used to manually control segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        recordButton.enabled = true
        recordingText.hidden = true;
        recordLabel.hidden = false
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
}

