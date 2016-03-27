import UIKit

class Repository: NSObject {
    
    var name:String?
    var descriptionText:String?
    var ownerLogin:String?
    var ownerAvatarUrl:String?
    var starsCount:NSNumber?
    var forksCount:NSNumber?
    
    class func fromArrayOfDictionaries(arrayOfDictionaries: [[String : AnyObject]]) -> [Repository] {
        var array = [Repository]()
        
        for dic in arrayOfDictionaries {
            array.append(self.fromDictionary(dic))
        }
        
        return array
    }
    
    
    class func fromDictionary(dictionary: [String : AnyObject]) -> Repository {
        let repository = Repository()

        repository.name = dictionary["name"] as? String ?? ""
        repository.descriptionText = dictionary["description"] as? String ?? ""
        repository.starsCount = dictionary["stargazers_count"] as? NSNumber ?? 0
        repository.forksCount = dictionary["forks_count"] as? NSNumber ?? 0
        
        if let ownerDictionary = dictionary["owner"] as? [String : AnyObject] {
            repository.ownerLogin = ownerDictionary["login"] as? String ?? ""
            repository.ownerAvatarUrl = ownerDictionary["avatar_url"] as? String ?? ""
        }
        
        return repository
    }
    
}
