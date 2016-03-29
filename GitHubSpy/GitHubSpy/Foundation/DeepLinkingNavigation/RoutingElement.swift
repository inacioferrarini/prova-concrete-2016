import UIKit

class RoutingElement: NSObject {

    let pattern:String
    let handler:(([NSObject : AnyObject]) -> Bool)
    
    init(pattern:String, handler:(([NSObject : AnyObject]) -> Bool)) {
        self.pattern = pattern
        self.handler = handler
        super.init()
    }
    
}
