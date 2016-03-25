import JLRoutes
import UIKit

class NavigationRouter: NSObject {
    
    let coreDataStack: CoreDataStack!
    let baseNavigationController: UINavigationController!
    
    init(coreDataStack: CoreDataStack!, baseNavigationController: UINavigationController!) {
        self.coreDataStack = coreDataStack
        self.baseNavigationController = baseNavigationController
    }
    
    func registerRoutes() {
        let routes = JLRoutes(forScheme: "GitHubSpy")
        
        routes.addRoute("/") { (params: [NSObject : AnyObject]) -> Bool in
            
            print("Showing root ... ")
            
            return true
        }
        
        routes.addRoute("/pr/:owner/:repo") { (params: [NSObject : AnyObject]) -> Bool in
            guard let owner = params["owner"] as? String else { return false }
            guard let repository = params["repo"] as? String else { return false }
            
            print("Showing repository \(repository) from user \(owner)")
            
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
    
}
