//
//  MicrophonePermissionsUITests.swift
//  DespensoUITests
//
//  Created by Eduardo Gutiérrez Silva on 10/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import XCTest

class RecordingViewUITests: XCTestCase {

    let app = XCUIApplication()
    var interruptionMonitor: NSObjectProtocol!
    let alertDescription = "“Despenso” Would Like to Access the Microphone"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.resetAuthorizationStatus(for: .microphone)

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.removeUIInterruptionMonitor(interruptionMonitor)
    }

    func testPermissinoGrantedOnFirstTimeUsage() throws {
        
        self._tapOnPermissionChoice("OK")
        
        let recordButton = app.buttons["Record my list!"]
        let playButton = app.buttons["Start Playing"]
        
        XCTAssert(recordButton.exists)
        XCTAssert(recordButton.isEnabled)
        
        XCTAssert(playButton.exists)
        XCTAssert(playButton.isEnabled)
        
        
        // Recording manually stopped
        
        app.buttons["Record my list!"].tap()
        XCTAssertFalse(playButton.isEnabled)
        
        app.buttons["Stop recording"].tap()
        XCTAssert(playButton.isEnabled)
        
        playButton.tap()
        XCTAssertFalse(recordButton.isEnabled)
        
        sleep(1)
        
        XCTAssert(recordButton.isEnabled)
        XCTAssert(playButton.exists)
    }
    
    func testPermissionDeinedOnFirstTimeUsage() {
        self._tapOnPermissionChoice("Don’t Allow")
        
        XCTAssertFalse(app.buttons["Record my list!"].isEnabled)
        XCTAssert(app.staticTexts["Please allow microphone permissions to record your list"].exists)
        XCTAssertFalse(app.buttons["Start Playing"].isEnabled)
        
    }
    
    // MARK: Helper functions
    
    func _tapOnPermissionChoice(_ buttonText: String) {
        interruptionMonitor = addUIInterruptionMonitor(withDescription: alertDescription) { (alert) -> Bool in
            if alert.buttons[buttonText].exists {
                alert.buttons[buttonText].tap()
                return true
            }
            return false
        }
        
        app.swipeUp()
    }

}
