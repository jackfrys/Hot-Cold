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
