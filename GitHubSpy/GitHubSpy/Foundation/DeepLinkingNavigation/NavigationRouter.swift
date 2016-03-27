import JLRoutes
import UIKit

class NavigationRouter: NSObject {
    
    let schema:String!
    let coreDataStack: CoreDataStack!
    let baseNavigationController: UINavigationController!
    let logger:Logger!
    
    init(schema:String!, coreDataStack: CoreDataStack!, baseNavigationController: UINavigationController!, logger:Logger!) {
        self.schema = schema
        self.coreDataStack = coreDataStack
        self.baseNavigationController = baseNavigationController
        self.logger = logger
        super.init()
    }
    
    func registerRoutes() {
        let routes = JLRoutes(forScheme: self.schema)
        
        routes.addRoute("/") { (params: [NSObject : AnyObject]) -> Bool in
            
            self.logger.logInfo("Showing root ... ")
            
            return true
        }
        
        routes.addRoute("/pr/:owner/:repo") { (params: [NSObject : AnyObject]) -> Bool in
            guard let owner = params["owner"] as? String else { return false }
            guard let repository = params["repo"] as? String else { return false }
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let appContext = delegate.appContext!
            let context = self.coreDataStack.managedObjectContext
            
            let viewController = ViewControllerManager().pullRequestListTableViewController(appContext)
            if let owner = EntityAuthor.entityAuthorWithLogin(owner, inManagedObjectContext: context),
                let repository = EntityRepository.entityRepositoryWithName(repository, owner: owner, inManagedObjectContext: context) {
                viewController.repository = repository
            }
            self.baseNavigationController.pushViewController(viewController, animated: true)
            
            return true
        }
    }
    
    func dispatch(url:NSURL) -> Bool {
        let result = JLRoutes.canRouteURL(url)
        if (result) {
            JLRoutes.routeURL(url)
        }
        
        return result
    }
    
    func navigateInternal(targetUrl:String) {
        let completeUrl = NSURL(string: "\(self.schema):/\(targetUrl)")
        if let url = completeUrl {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}
