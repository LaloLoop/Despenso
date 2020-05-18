//
//  FailingRecorderMock.swift
//  DespensoTests
//
//  Created by Eduardo Gutiérrez Silva on 17/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import AVFoundation
@testable import Despenso

class FailingRecorderMock: SuccessfulRecorderMock {
    
    override func recordWith(url: URL, settings: [String : Any], delegate: AVAudioRecorderDelegate) throws -> StopRecorder {
        throw despensoInternalError
    }
}
