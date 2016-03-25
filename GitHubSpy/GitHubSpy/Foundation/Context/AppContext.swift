import UIKit

class AppContext: NSObject {
    
    let navigationController: UINavigationController!
    let coreDataStack: CoreDataStack!
    let router: NavigationRouter!
    
    init(navigationController: UINavigationController!, coreDataStack: CoreDataStack!, router: NavigationRouter) {
        self.navigationController = navigationController
        self.coreDataStack = coreDataStack
        self.router = router
        super.init()
    }
    
}
