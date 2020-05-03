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
}

final class Recorder {
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
}
