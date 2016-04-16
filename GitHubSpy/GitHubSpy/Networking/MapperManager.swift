import UIKit
import EasyMapping

class MapperManager: NSObject {
    
    class func entityAuthorObjectMapping() -> EKManagedObjectMapping {
        let mapping = EKManagedObjectMapping(entityName: EntityAuthor.simpleClassName())
        mapping!.mapPropertiesFromArray(["login"])
        mapping!.mapPropertiesFromDictionary(["avatar_url" : "avatarUrl"])
        mapping!.primaryKey = "login"
        return mapping
    }
    
    class func entityRepositoryObjectMapping() -> EKManagedObjectMapping {
        let mapping = EKManagedObjectMapping(entityName: EntityRepository.simpleClassName())
        mapping.mapPropertiesFromArray(["name"])
        mapping.mapPropertiesFromDictionary(["description" : "descriptionText",
            "stargazers_count" : "starsCount",
            "forks_count" : "forksCount"])
        mapping.hasOne(EntityAuthor.self, forKeyPath: "owner", forProperty: "owner",
            withObjectMapping: MapperManager.entityAuthorObjectMapping())
        mapping.primaryKey = "name"
        return mapping
    }
    
    class func entityPullRequestObjectMapping(repository:EntityRepository) -> EKManagedObjectMapping {
        let mapping = EKManagedObjectMapping(entityName: EntityPullRequest.simpleClassName())
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZZZ"
        
        mapping.mapPropertiesFromArray(["title", "body"])
        mapping.mapPropertiesFromDictionary(["id" : "uid", "html_url" : "url"])
        mapping.hasOne(EntityAuthor.self, forKeyPath: "user", forProperty: "owner", withObjectMapping: MapperManager.entityAuthorObjectMapping())
        
        mapping.mapKeyPath("state", toProperty: "status") { (property: String!, value: AnyObject!, context: NSManagedObjectContext!) -> AnyObject! in

            if let str = value as? String {
                if str == "closed" {
                    return "C"
                } else {
                    return "O"
                }
            }
            
            return "C"
        }
                
        mapping.mapKeyPath("head.repo", toProperty: "repository") { (property:String!, value:AnyObject!, context:NSManagedObjectContext!) -> AnyObject! in
            return repository
        }
        
        mapping.mapKeyPath("created_at", toProperty: "created", withDateFormatter: dateFormatter)
        mapping.mapKeyPath("updated_at", toProperty: "lastUpdated", withDateFormatter: dateFormatter)
        mapping.primaryKey = "uid"
        
        return mapping
    }
    
}
