import UIKit

class AppContext: NSObject {
    
    let navigationController: UINavigationController
    let coreDataStack: CoreDataStack
    let syncRules: DataSyncRules
    let router: NavigationRouter
    let logger: Logger
    
    init(navigationController: UINavigationController, coreDataStack: CoreDataStack, syncRules: DataSyncRules, router: NavigationRouter, logger: Logger) {
        self.navigationController = navigationController
        self.coreDataStack = coreDataStack
        self.syncRules = syncRules
        self.router = router
        self.logger = logger
        super.init()
    }
    
}
