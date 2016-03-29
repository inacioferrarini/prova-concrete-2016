import UIKit

class AppContext: NSObject {
    
    let navigationController: UINavigationController
    let coreDataStack: CoreDataStack
    let router: NavigationRouter
    let logger: Logger
    
    init(navigationController: UINavigationController, coreDataStack: CoreDataStack, router: NavigationRouter, logger: Logger) {
        self.navigationController = navigationController
        self.coreDataStack = coreDataStack
        self.router = router
        self.logger = logger
        super.init()
    }
    
}
