//
//  Recorder.swift
//  Despenso
//
//  Created by Eduardo Gutiérrez Silva on 02/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import Foundation
import AVFoundation


protocol RecorderDelegate {
    func userPermission(_ sender: Recorder, allowed: Bool)
    func setupError(_ sender: Recorder, error: String)
    func recordingStarted(_ sender: Recorder)
    func recordingFinished(_ sender: Recorder, successfully: Bool)
    func recordingErrorDidOccur(_ sender: Recorder, error: String)
    func playingStarted(_ sender: Recorder)
    func playingFinished(_ sender: Recorder, successfully: Bool)
    func playingErrorDidOccur(_ sender: Recorder, error: String)
}

final class Recorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var recordingSession: AVAudioSession
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var delegate: RecorderDelegate?
    
    init(delegate: RecorderDelegate) {
        recordingSession = AVAudioSession.sharedInstance()
        self.delegate = delegate
    }
    
    func setupPermissions() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    self.delegate?.userPermission(self, allowed: allowed)
                }
            }
        } catch {
            self.delegate?.setupError(self, error: "Error requesting permission: \(error).")
        }
    }
    
    func startRecording() {
        let audioFilename = _getFileURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            delegate?.recordingStarted(self)
            
        } catch {
            stopRecording()
            self.delegate?.recordingFinished(self, successfully: false)
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func startPlaying() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: _getFileURL())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 30.0
            
            audioPlayer.play()
            
            self.delegate?.playingStarted(self)
            
        } catch {
            stopPlaying()
            self.delegate?.playingFinished(self, successfully: false)
        }
    }
    
    func stopPlaying() {
        audioPlayer.stop()
        audioPlayer = nil
    }
    
    //MARK: Private methods
    
    private func _getFileURL() -> URL {
        let path = _getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    private func _getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: Delegate methods

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.delegate?.recordingFinished(self, successfully: flag)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        self.delegate?.recordingErrorDidOccur(self, error: error?.localizedDescription ?? "Unknown")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.delegate?.playingFinished(self, successfully: flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.delegate?.playingErrorDidOccur(self, error: error?.localizedDescription ?? "Unknown")
    }
}
