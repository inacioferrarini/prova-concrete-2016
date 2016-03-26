import Foundation
import CoreData

class EntityRepository: NSManagedObject {

    class func fetchEntityRepositoryByName(name: String, inManagedObjectContext context:NSManagedObjectContext) -> EntityRepository? {
        
        guard name.characters.count > 0 else {
            return nil
        }
        
        let request:NSFetchRequest = NSFetchRequest(entityName: self.entityName())
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
            let newEntityRepository = NSEntityDescription.insertNewObjectForEntityForName(self.entityName(), inManagedObjectContext: context) as! EntityRepository
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
    
}
