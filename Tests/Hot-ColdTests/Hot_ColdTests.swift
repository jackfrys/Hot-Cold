import XCTest
@testable import Hot_Cold

class Hot_ColdTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Hot_Cold().text, "Hello, World!")
    }


    static var allTests : [(String, (Hot_ColdTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
