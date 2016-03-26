import Foundation
import CoreData

extension NSManagedObject {
    
    class public func entityName() -> String {
        let fullClassName:String = NSStringFromClass(object_getClass(self))
        let classNameComponents = fullClassName.characters.split{$0 == "."}.map(String.init)
        return classNameComponents.last!
    }
    
}