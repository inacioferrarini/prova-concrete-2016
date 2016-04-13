import UIKit
import EasyMapping

class MapperManager: NSObject {
    
    class func entityAuthorObjectMapping() -> EKManagedObjectMapping {
        let mapping = EKManagedObjectMapping(entityName: EntityAuthor.simpleClassName())
        mapping.mapPropertiesFromArray(["login"])
        mapping.mapPropertiesFromDictionary(["avatar_url" : "avatarUrl"])
        mapping.primaryKey = "login"
        return mapping
    }
    
    class func entityRepositoryObjectMapping() -> EKManagedObjectMapping {
        let mapping = EKManagedObjectMapping(entityName: EntityRepository.simpleClassName())
        mapping.mapPropertiesFromArray(["name"])
        mapping.mapPropertiesFromDictionary(["description" : "descriptionText",
            "stargazers_count" : "starsCount",
            "forks_count" : "forksCount"])
//        mapping.hasOne(EntityAuthor.self, forKeyPath: "owner", forProperty: "owner", withObjectMapping: MapperManager.entityAuthorObjectMapping())
        mapping.primaryKey = "name"
        return mapping
    }
    
    class func entityPullRequestObjectMapping() -> EKManagedObjectMapping {
        let mapping = EKManagedObjectMapping(entityName: EntityPullRequest.simpleClassName())
        mapping.mapPropertiesFromArray(["id", "title", "body", "state"])
        mapping.mapPropertiesFromDictionary(["created_at" : "created",
            "updated_at" : "lastUpdated",
            "html_url" : "url"])
        mapping.primaryKey = "id"
        
        // mapear user.login
        // mapear user.avatar_url
        
        return mapping
    }
    
}
