import Foundation
import CoreData

class EntityPullRequest: NSManagedObject {
    
    class func fetchEntityPullRequestByUid(uid: NSNumber, inManagedObjectContext context:NSManagedObjectContext) -> EntityPullRequest? {
        
        guard uid.integerValue > 0 else {
            return nil
        }
        
        let request:NSFetchRequest = NSFetchRequest(entityName: self.entityName())
        request.predicate = NSPredicate(format: "uid = %@", uid)
        
        let matches = (try! context.executeFetchRequest(request)) as! [EntityPullRequest]
        if (matches.count > 0) {
            return matches.last
        }
        
        return nil
    }
    
    class func entityPullRequestWithUid(uid:NSNumber, owner: EntityAuthor, repository: EntityRepository, inManagedObjectContext context:NSManagedObjectContext) -> EntityPullRequest? {
        return self.entityPullRequestWithUid(uid, owner: owner, repository: repository, title: nil, body: nil, created: nil, lastUpdated: nil, url: nil, inManagedObjectContext: context)
    }
    
    class func entityPullRequestWithUid(uid:NSNumber, owner: EntityAuthor, repository: EntityRepository, title: String?, body: String?, created: NSDate?, lastUpdated: NSDate?, url: String?, inManagedObjectContext context:NSManagedObjectContext) -> EntityPullRequest? {
        
        guard uid.integerValue > 0 else {
            return nil
        }
        
        var entityPullRequest:EntityPullRequest? = fetchEntityPullRequestByUid(uid, inManagedObjectContext: context)
        if entityPullRequest == nil {
            let newEntityPullRequest = NSEntityDescription.insertNewObjectForEntityForName(self.simpleClassName(), inManagedObjectContext: context) as! EntityPullRequest
            newEntityPullRequest.uid = uid
            newEntityPullRequest.owner = owner
            newEntityPullRequest.repository = repository
            entityPullRequest = newEntityPullRequest
        }
        
        if let entityPullRequest = entityPullRequest {
            
            if let title = title {
                entityPullRequest.title = title
            }
            
            if let body = body {
                entityPullRequest.body = body
            }
            
            if let created = created {
                entityPullRequest.created = created
            }
            
            if let lastUpdated = lastUpdated {
                entityPullRequest.lastUpdated = lastUpdated
            }
            
            if let url = url {
                entityPullRequest.url = url
            }
            
        }
        
        return entityPullRequest
    }
    
}
