//
//  AudioRecorderProtocol.swift
//  Despenso
//
//  Created by Eduardo Gutiérrez Silva on 17/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import Foundation
import AVFoundation

typealias StopRecorder = () -> Void

protocol AudioRecorderProtocol {
    func recordWith(url: URL, settings: [String: Any], delegate: AVAudioRecorderDelegate) throws -> StopRecorder
}
