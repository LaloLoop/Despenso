//
//  Recorder.swift
//  Despenso
//
//  Created by Eduardo Gutiérrez Silva on 02/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//
// Implemented with help from the following sources:
// * Views lifecycles: https://www.hackingwithswift.com/quick-start/swiftui/how-to-respond-to-view-lifecycle-events-onappear-and-ondisappear
// * Understanding delegates: https://www.appcoda.com/swift-delegate/
// * Record and Play audio in iOS Swift: https://gist.github.com/vikaskore/e5d9fc91feac455d6b4778b3d768a6e8

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
    var audioSession: AudioSessionProtocol
    var recorderCreator: AudioRecorderProtocol
    var stopRecorder: StopRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var delegate: RecorderDelegate?
    
    // MARK: Public API
    
    init(
        session audioSession: AudioSessionProtocol = AudioSession(),
        recorderCreator: AudioRecorderProtocol = AudioRecorder(),
        delegate: RecorderDelegate) {
        self.audioSession = audioSession
        self.recorderCreator = recorderCreator
        self.delegate = delegate
    }
    
    func setupPermissions(_ expectation: (() -> Void)? = nil) {
        do {
            try audioSession.requestRecordPermissionWith(.playback, mode: .default, active: true) { [unowned self] allowed in
                DispatchQueue.main.async {
                    self.delegate?.userPermission(self, allowed: allowed)
                    
                    expectation?()
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
            stopRecorder = try self.recorderCreator.recordWith(
                url: audioFilename,
                settings: settings,
                delegate: self
            )
            
            delegate?.recordingStarted(self)
            
        } catch {
            stopRecording()
            self.delegate?.recordingErrorDidOccur(self, error: "Error recording: \(error).")
        }
    }
    
    func stopRecording() {
        stopRecorder?()
        self.delegate?.recordingFinished(self, successfully: false)
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
        self.delegate?.playingFinished(self, successfully: false)
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
