import JLRoutes
import UIKit

class NavigationRouter: NSObject {
    
    let router:JLRoutes
    let schema:String
    let logger:Logger
    
    init(router: JLRoutes, schema: String, logger: Logger) {
        self.router = router
        self.schema = schema
        self.logger = logger
        super.init()
    }

    convenience init(schema:String, logger: Logger) {
        self.init(router: JLRoutes(forScheme: schema), schema: schema, logger: logger)
    }
    
    func registerRoutes(appRoutes: [RoutingElement]) {
        for r:RoutingElement in appRoutes {
            self.router.addRoute(r.pattern, handler: r.handler)
        }
    }
    
    func dispatch(url:NSURL) -> Bool {
        let result = self.router.canRouteURL(url)
        if (result) {
            self.router.routeURL(url)
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
