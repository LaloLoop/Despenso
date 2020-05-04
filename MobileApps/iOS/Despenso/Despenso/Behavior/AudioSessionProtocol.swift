//
//  AudioSessionProtocol.swift
//  Despenso
//
//  Created by Eduardo Gutiérrez Silva on 03/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioSessionProtocol {
    func requestRecordPermissionWith(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, active: Bool, _ response: @escaping PermissionBlock) throws
}
