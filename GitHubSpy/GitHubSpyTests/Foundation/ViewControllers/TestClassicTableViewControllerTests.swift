import XCTest

class TestClassicTableViewControllerTests: XCTestCase {
   
    var viewController: TestClassicTableViewController!
    
    override func setUp() {
        super.setUp()
        let appContext = TestUtil().appContext()
        let navigationController = TestUtil().rootViewController()
        viewController = TestUtil().testClassicTableViewController(appContext)
        navigationController.pushViewController(viewController, animated: true)
        
        UIApplication.sharedApplication().keyWindow!.rootViewController = navigationController
        
        let _ = navigationController.view
        let _ = viewController.view
    }
    
    
    func test_viewDidLoad_mustNotCrash() {
        self.viewController.viewDidLoad()
    }
    
    
    func test_createDataSource_mustReturnNil() {
        XCTAssertNil(self.viewController.createDataSource())
    }
    
    
    func test_createDelegate_mustReturnNil() {
        XCTAssertNil(self.viewController.createDelegate())
    }
    
    func test_cellForRowAtIndexPath_mustReturnNotNil() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = self.viewController.tableView(self.viewController.tableView!, cellForRowAtIndexPath: indexPath)
        XCTAssertNotNil(cell)
    }
    
}
