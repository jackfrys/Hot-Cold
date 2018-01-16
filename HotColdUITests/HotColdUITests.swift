//
//  HotColdUITests.swift
//  HotColdUITests
//
//  Created by Jack Frysinger on 1/15/18.
//  Copyright © 2018 Jack Frysinger. All rights reserved.
//

import XCTest

class HotColdUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
    
    func testNavScreen() {
        snapshot("01StartScreen")
        XCUIApplication().buttons["GO"].tap()
        snapshot("02NavScreen")
    }
    
}
