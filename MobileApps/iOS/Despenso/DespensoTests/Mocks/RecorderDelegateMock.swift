//
//  RecorderDelegateMock.swift
//  DespensoTests
//
//  Created by Eduardo Gutiérrez Silva on 03/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import Foundation
@testable import Despenso

class RecorderDelegateMock: RecorderDelegate {
    var userPermissionCalled = false
    var setupErrorCalled = false
    var recordingStartedCalled = false
    var recordingFinishedCalled = false
    var recordingErrorDidOccurCalled = false
    var playingStartedCalled = false
    var playingFinishedCalled = false
    var playingErrorDidOccurCalled = false
    
    var allowed = false
    var error = ""
    
    var finishedSuccessfully = false
    
    func userPermission(_ sender: Recorder, allowed: Bool) {
        self.userPermissionCalled = true
        self.allowed = allowed
    }
    
    func setupError(_ sender: Recorder, error: String) {
        self.setupErrorCalled = true
        self.error = error
    }
    
    func recordingStarted(_ sender: Recorder) {
        self.recordingStartedCalled = true
    }
    
    func recordingFinished(_ sender: Recorder, successfully: Bool) {
        self.recordingFinishedCalled = true
        self.finishedSuccessfully = successfully
    }
    
    func recordingErrorDidOccur(_ sender: Recorder, error: String) {
        self.recordingErrorDidOccurCalled = true
        self.error = error
    }
    
    func playingStarted(_ sender: Recorder) {
        self.playingStartedCalled = true
    }
    
    func playingFinished(_ sender: Recorder, successfully: Bool) {
        self.playingFinishedCalled = true
        self.finishedSuccessfully = successfully
    }
    
    func playingErrorDidOccur(_ sender: Recorder, error: String) {
        self.playingErrorDidOccurCalled = true
        self.error = error
    }
}
