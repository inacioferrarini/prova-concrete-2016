import XCTest
@testable import GitHubSpy

class LoggerTests: XCTestCase {
    
    func test_logger_mustNotCrash() {
        Logger().logErrorMessage("Error Message")
    }
    
}
