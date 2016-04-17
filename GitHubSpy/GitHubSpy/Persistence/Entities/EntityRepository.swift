import Foundation
import CoreData
import EasyMapping
import York

class EntityRepository: EKManagedObjectModel {

    class func fetchEntityRepositoryByName(name: String, inManagedObjectContext context:NSManagedObjectContext) -> EntityRepository? {
        
        guard name.characters.count > 0 else {
            return nil
        }
        
        let request:NSFetchRequest = NSFetchRequest(entityName: self.simpleClassName())
        request.predicate = NSPredicate(format: "name = %@", name)
        
        let matches = (try! context.executeFetchRequest(request)) as! [EntityRepository]
        if (matches.count > 0) {
            return matches.last
        }
        
        return nil
    }
    
    class func entityRepositoryWithName(name:String, owner: EntityAuthor, inManagedObjectContext context:NSManagedObjectContext) -> EntityRepository? {
        return self.entityRepositoryWithName(name, owner: owner, descriptionText: nil, forksCount: nil, starsCount: nil, pullRequests: nil, inManagedObjectContext: context)
    }
    
    class func entityRepositoryWithName(name:String, owner: EntityAuthor, descriptionText: String?, forksCount: NSNumber?, starsCount: NSNumber?, pullRequests: NSSet?, inManagedObjectContext context:NSManagedObjectContext) -> EntityRepository? {
        
        guard name.characters.count > 0 else {
            return nil
        }
        
        var entityRepository:EntityRepository? = fetchEntityRepositoryByName(name, inManagedObjectContext: context)
        if entityRepository == nil {
            let newEntityRepository = NSEntityDescription.insertNewObjectForEntityForName(self.simpleClassName(), inManagedObjectContext: context) as! EntityRepository
            newEntityRepository.name = name
            newEntityRepository.owner = owner
            entityRepository = newEntityRepository
        }
        
        if let entityRepository = entityRepository {
            
            if let descriptionText = descriptionText {
                entityRepository.descriptionText = descriptionText
            }
            
            if let forksCount = forksCount {
                entityRepository.forksCount = forksCount
            }
            
            if let starsCount = starsCount {
                entityRepository.starsCount = starsCount
            }
                        
            if let pullRequests = pullRequests {
                entityRepository.pullRequests = pullRequests
            }
            
        }
        
        return entityRepository
    }
    
    func openPullRequestCount(inManagedObjectContext context:NSManagedObjectContext) -> Int {
        let request:NSFetchRequest = NSFetchRequest(entityName: "EntityPullRequest")
        let pullRequestRepositoryName = NSPredicate(format: "repository.name = %@", self.name!)
        let pullRequestStatus = NSPredicate(format: "status = %@", "O")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pullRequestRepositoryName, pullRequestStatus])
        return context.countForFetchRequest(request, error: nil)
    }
    
    func closedPullRequestCount(inManagedObjectContext context:NSManagedObjectContext) -> Int {
        let request:NSFetchRequest = NSFetchRequest(entityName: "EntityPullRequest")
        let pullRequestRepositoryName = NSPredicate(format: "repository.name = %@", self.name!)
        let pullRequestStatus = NSPredicate(format: "status = %@", "C")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pullRequestRepositoryName, pullRequestStatus])
        return context.countForFetchRequest(request, error: nil)
    }
    
}
