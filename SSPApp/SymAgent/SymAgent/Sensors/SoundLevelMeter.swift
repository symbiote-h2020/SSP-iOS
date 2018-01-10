//
//  SoundLevelMeter.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 01/12/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import AVFoundation
import CoreAudio
import Foundation

class SoundLevelMeter {
    
    init() {
        initDecibel()
    }
    
    //MARK: decibel meter
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    
    let LEVEL_THRESHOLD: Float = -10.0
    
    func initDecibel() {
        
        
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
            
        } catch {
            return
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
        levelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
        
    }
    
    @objc func levelTimerCallback() {
        recorder.updateMeters()
        
        let level = recorder.averagePower(forChannel: 0)
       // let isLoud = level > LEVEL_THRESHOLD
        
        log("sound level = \(level) dB")
    }
    
}
