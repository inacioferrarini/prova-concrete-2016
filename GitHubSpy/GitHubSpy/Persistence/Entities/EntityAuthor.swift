import Foundation
import CoreData
import EasyMapping

class EntityAuthor: EKManagedObjectModel {
    
    class func fetchEntityAuthorByLogin(login: String, inManagedObjectContext context:NSManagedObjectContext) -> EntityAuthor? {
        
        guard login.characters.count > 0 else {
            return nil
        }
        
        let request:NSFetchRequest = NSFetchRequest(entityName: self.simpleClassName())
        request.predicate = NSPredicate(format: "login = %@", login)
        
        let matches = (try! context.executeFetchRequest(request)) as! [EntityAuthor]
        if (matches.count > 0) {
            return matches.last
        }
        
        return nil
    }
    
    class func entityAuthorWithLogin(login:String, inManagedObjectContext context:NSManagedObjectContext) -> EntityAuthor? {
        return self.entityAuthorWithLogin(login, firstName: nil, lastName: nil, avatarUrl: nil, repositories: nil, pullRequests: nil, inManagedObjectContext: context)
    }
    
    class func entityAuthorWithLogin(login:String, firstName: String?, lastName: String?, avatarUrl: String?, repositories: NSSet?, pullRequests: NSSet?, inManagedObjectContext context:NSManagedObjectContext) -> EntityAuthor? {
        
        guard login.characters.count > 0 else {
            return nil
        }
        
        var entityAuthor:EntityAuthor? = fetchEntityAuthorByLogin(login, inManagedObjectContext: context)
        if entityAuthor == nil {
            let newEntityAuthor = NSEntityDescription.insertNewObjectForEntityForName(self.simpleClassName(), inManagedObjectContext: context) as! EntityAuthor
            newEntityAuthor.login = login
            entityAuthor = newEntityAuthor
        }
        
        if let entityAuthor = entityAuthor {
            
            if let firstName = firstName {
                entityAuthor.firstName = firstName
            }
            
            if let lastName = lastName {
                entityAuthor.lastName = lastName
            }
            
            if let avatarUrl = avatarUrl {
                entityAuthor.avatarUrl = avatarUrl
            }
            
            if let repositories = repositories {
                entityAuthor.repositories = repositories
            }
            
            if let pullRequests = pullRequests {
                entityAuthor.pullRequests = pullRequests
            }

        }
        
        return entityAuthor
    }
    
}
