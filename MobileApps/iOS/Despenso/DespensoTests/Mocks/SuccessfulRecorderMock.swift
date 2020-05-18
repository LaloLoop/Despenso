//
//  SuccessfulRecorderMock.swift
//  DespensoTests
//
//  Created by Eduardo Gutiérrez Silva on 17/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import AVFoundation
@testable import Despenso

class SuccessfulRecorderMock: AudioRecorderProtocol {
    var recordWithCalled = false
    var stopRecorderCalled = false
    
    func recordWith(url: URL, settings: [String : Any], delegate: AVAudioRecorderDelegate) throws -> StopRecorder {
        recordWithCalled = true
        
        return { self.stopRecorderCalled = true }
    }
    
    
}
