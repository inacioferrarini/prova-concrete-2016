import JLRoutes

class JLRoutesMock: JLRoutes {
    
    override func routeURL(URL: NSURL?) -> Bool {
        return true
    }
    
    override func canRouteURL(URL: NSURL?) -> Bool {
        return true
    }
    
}
