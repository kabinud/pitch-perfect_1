//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by kabinu on 3/16/15.
//  Copyright (c) 2015 kabinu. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
         
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

        var session = AVAudioSession.sharedInstance()
        
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    
    }
    
    @IBAction func stopAudio(sender: UIButton) {
    
        audioPlayer.stop()
    
    }
    
    @IBAction func playFast(sender: UIButton) {
        
        stopAudioEngine()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }

    @IBAction func playSlow(sender: UIButton) {
        
        stopAudioEngine()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 0.5
        audioPlayer.play()
        
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        //raise the pitch
        playAudioWithVariablePitch(1000)
        
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        stopAudioEngine()
        
        //create a player node to audio engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //create a pitch effect to attach to the player node
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //connect the output and pitch to the audio engine
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //output the audio file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        //slow the pitch
        playAudioWithVariablePitch(-1000)
        
    }
    
    func stopAudioEngine(){
        
        //make sure to stop and reset audio engine to prevent overlapping sounds
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }
}