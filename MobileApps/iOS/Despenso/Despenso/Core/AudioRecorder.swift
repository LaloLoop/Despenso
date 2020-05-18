//
//  AudioRecorder.swift
//  Despenso
//
//  Created by Eduardo Gutiérrez Silva on 17/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import Foundation
import AVFoundation

final class AudioRecorder: AudioRecorderProtocol {
    func recordWith(url: URL, settings: [String : Any], delegate: AVAudioRecorderDelegate) throws -> StopRecorder {
        let audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder.delegate = delegate
        audioRecorder.record()
        
        return { audioRecorder.stop() }
    }

}
