import XCTest
@testable import GitHubSpy

class BaseViewControllerTests: XCTestCase {
    
    var viewController: BaseViewController!
    
    override func setUp() {
        super.setUp()
        let appContext = TestUtil().appContext()
        let navigationController = TestUtil().rootViewController()
        viewController = TestUtil().baseViewController(appContext)
        navigationController.pushViewController(viewController, animated: true)
        
        UIApplication.sharedApplication().keyWindow!.rootViewController = navigationController
        
        let _ = navigationController.view
        let _ = viewController.view
    }
    
    func test_appContext_notNil() {
        XCTAssertNotNil(viewController.appContext)
    }
    
    func test_viewControllerTitle_nil() {
        XCTAssertNil(viewController.viewControllerTitle())
    }
    
}
