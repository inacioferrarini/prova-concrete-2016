import JLRoutes
import UIKit

class NavigationRouter: NSObject {
    
    let schema:String
    let logger:Logger
    
    init(schema:String, logger:Logger) {
        self.schema = schema
        self.logger = logger
        super.init()
    }
    
    func registerRoutes(appRoutes: [RoutingElement]) {
        let routes = JLRoutes(forScheme: self.schema)
        
        for r:RoutingElement in appRoutes {
            routes.addRoute(r.pattern, handler: r.handler)
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
    
    func navigateExternal(targetUrl:String) {
        let completeUrl = NSURL(string: targetUrl)
        if let url = completeUrl {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}
