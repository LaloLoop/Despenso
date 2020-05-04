//
//  AudioSession.swift
//  Despenso
//
//  Created by Eduardo Gutiérrez Silva on 03/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import Foundation
import AVFoundation

final class AudioSession: AudioSessionProtocol {
    
    var audioSession: AVAudioSession
    
    init(_ audioSession: AVAudioSession = AVAudioSession.sharedInstance()) {
        self.audioSession = audioSession
    }
    
    func requestRecordPermissionWith(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, active: Bool, _ response: @escaping PermissionBlock) throws {
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
        audioSession.requestRecordPermission(response)
    }
    
    
}
