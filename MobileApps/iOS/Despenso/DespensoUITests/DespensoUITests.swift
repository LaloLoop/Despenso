//
//  DespensoUITests.swift
//  DespensoUITests
//
//  Created by Eduardo Gutiérrez Silva on 02/05/20.
//  Copyright © 2020 Lalogs. All rights reserved.
//

import XCTest

class DespensoUITests: XCTestCase {
    
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
        
    }
    
    func testPermissionDeinedOnFirstTimeUsage() {
        self._tapOnPermissionChoice("Don’t Allow")
        
        XCTAssertFalse(app.buttons["Record my list!"].isEnabled)
        XCTAssert(app.staticTexts["Please allow microphone permissions to record your list"].exists)
        XCTAssertFalse(app.buttons["Start Playing"].isEnabled)
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
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
