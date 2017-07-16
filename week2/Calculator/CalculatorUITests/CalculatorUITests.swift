//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by YeongsikLee on 2017. 7. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.staticTexts["+/-"].tap()
        
        let staticText = app.staticTexts["%"]
        staticText.tap()
        staticText.tap()
        app.staticTexts["/"].tap()
        app.staticTexts["*"].tap()
        app.staticTexts["9"].tap()
        app.staticTexts["8"].tap()
        app.staticTexts["7"].tap()
        app.staticTexts["4"].tap()
        XCUIDevice.shared().orientation = .landscapeLeft
        app.staticTexts["e"].tap()
        app.staticTexts["tanh"].tap()
        app.staticTexts["cos"].tap()
        XCUIDevice.shared().orientation = .portrait
        
        let width = app.frame.width
        XCTAssertTrue(isBetween(pos: Double(app.staticTexts["/"].frame.origin.x / width), from : 0.76, to : 1.0), "!!!")
    }
    
    func isBetween(pos: Double, from: Double, to: Double) -> Bool
    {
        return from <= pos && pos <= to
    }
    
}
