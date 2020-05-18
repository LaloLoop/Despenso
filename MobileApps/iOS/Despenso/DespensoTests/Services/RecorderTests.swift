//
//  RecorderTests.swift
//  DespensoTests
//
//  Created by Eduardo Gutiérrez Silva on 03/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import XCTest
@testable import Despenso

class RecorderTests: XCTestCase {
    var recorderDelegate: RecorderDelegate!
    var audioSessionMock: AudioSessionProtocol!
    var audioRecorderMock: AudioRecorderProtocol!
    
    var recorder: Recorder!
    
    override func setUpWithError() throws {
        // Default implementation for audio session
        audioSessionMock = UserRespondedWithMock(true)
        recorderDelegate = RecorderDelegateMock()
    }
    
    override func tearDownWithError() throws {
        recorderDelegate = nil
        audioSessionMock = nil
        audioRecorderMock = nil
        recorder = nil
    }
    
    func testSetupPermissionsAllowed() throws {
        let delegate = try self._setupUserAllowed(true)
        
        XCTAssert(delegate.allowed, "User choice was not properly passed")
    }
    
    func testSetupPermissionsNoAllowed() throws {
        let delegate = try self._setupUserAllowed(false)
        
        XCTAssert(!delegate.allowed, "User choice was not properly passed")
    }
    
    func testSetupFailedWithError() throws {
        audioSessionMock = SetupErroredMock()
        recorder = Recorder(session: audioSessionMock, delegate: recorderDelegate)
        
        let delegate = recorderDelegate as! RecorderDelegateMock
        
        recorder.setupPermissions()
        
        XCTAssert(delegate.setupErrorCalled, "Did not notify error to delegate")
        XCTAssert(delegate.error.contains("Internal API error"), "Error message not rendered in delegate's message")
    }
    
    func testRecordingStartsSuccessfully() throws {
        audioRecorderMock = SuccessfulRecorderMock()
        recorder = Recorder(
            session: audioSessionMock,
            recorderCreator: audioRecorderMock,
            delegate: recorderDelegate
        )
        
        recorder.startRecording()
        
        let delegate = recorderDelegate as! RecorderDelegateMock
        let audioRecorder = audioRecorderMock as! SuccessfulRecorderMock
        
        XCTAssert(delegate.recordingStartedCalled, "Did not call delegate on recording start")
        XCTAssert(audioRecorder.recordWithCalled, "Audio recorder was never created through creator")
        
        recorder.stopRecording()
        
        XCTAssert(audioRecorder.stopRecorderCalled, "Stop recorder callback was never called")
    }
    
    // MARK: Common setup and tests
    
    private func _setupUserAllowed(_ allowed: Bool) throws -> RecorderDelegateMock {
        audioSessionMock = UserRespondedWithMock(allowed)
        recorder = Recorder(session: audioSessionMock, delegate: recorderDelegate)
        let expectation = self.expectation(description: "Calling Delegate")
        
        recorder.setupPermissions() {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Assert functionality
        let delegate = recorderDelegate as! RecorderDelegateMock
        XCTAssert(delegate.userPermissionCalled, "Recorderd did not notify user choice")
        
        return delegate
    }
}
