import XCTest
import JLRoutes

class NavigationRouterTests: XCTestCase {
    
    override func setUp() {
        self.router = self.createNavigationRouter()
        super.setUp()
    }
    
    var router:NavigationRouter!
    
    func createNavigationRouter() -> NavigationRouter {
        let navigationRouter = NavigationRouter(schema: "TesteScheme", logger: Logger())
        return navigationRouter
    }
    
    func test_dispatch_mustReturnTrue() {
        let navigationRouter = NavigationRouter(router: JLRoutesMock(), schema:
                    "TesteScheme", logger: Logger())
        let result = navigationRouter.dispatch(NSURL(fileURLWithPath: "TesteScheme://invalidTestUrlScheme"))
        XCTAssertTrue(result)
    }
    
    func test_dispatch_mustReturnFalse() {
        let result = self.router.dispatch(NSURL(fileURLWithPath: "TesteScheme://invalidTestUrlScheme"))
        XCTAssertFalse(result)
    }
    
    func test_navigateInternal_mustSucceed() {
        self.router.navigateInternal("/testUrlScheme")
    }
    
    func test_navigateInternal_mustFail() {
        self.router.navigateInternal("/invalidTestUrlScheme")
    }
    
    func test_navigateExternal_mustSucceed() {
        self.router.navigateExternal("http://www.google.com.br")
    }
    
    func test_navigateExternal_mustFail() {
        self.router.navigateExternal("http://x/")
    }
    
}