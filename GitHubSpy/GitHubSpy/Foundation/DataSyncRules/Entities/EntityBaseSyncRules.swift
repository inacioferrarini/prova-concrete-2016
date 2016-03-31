import Foundation
import CoreData

class EntityBaseSyncRules: NSManagedObject {

    class func fetchEntityAutoBaseSyncRulesByName(name: String, inManagedObjectContext context:NSManagedObjectContext) -> EntityBaseSyncRules? {
        
        guard name.characters.count > 0 else {
            return nil
        }
        
        let request:NSFetchRequest = NSFetchRequest(entityName: self.entityName())
        request.predicate = NSPredicate(format: "name = %@", name)
        
        let matches = (try! context.executeFetchRequest(request)) as! [EntityBaseSyncRules]
        if (matches.count > 0) {
            return matches.last
        }
        
        return nil
    }
    
    func shouldRunSyncRuleWithName(name:String, date:NSDate, inManagedObjectContext context:NSManagedObjectContext) -> Bool {
        return false
    }
    
}