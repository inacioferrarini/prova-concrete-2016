import UIKit

class PullRequest: NSObject {

    var uid:NSNumber?
    var title:String?
    var body:String?
    var ownerLogin:String?
    var ownerAvatarUrl:String?
    var createdDate:NSDate?
    var updatedDate:NSDate?
    var url:String?
    var status:String?
    
    class func fromArrayOfDictionaries(arrayOfDictionaries: [[String : AnyObject]]) -> [PullRequest] {
        var array = [PullRequest]()
        
        for dic in arrayOfDictionaries {
            array.append(self.fromDictionary(dic))
        }
        
        return array
    }
    
    class func fromDictionary(dictionary: [String : AnyObject]) -> PullRequest {
        let pullRequest = PullRequest()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZZZ"
        
        pullRequest.uid = dictionary["id"] as? NSNumber ?? 0
        pullRequest.title = dictionary["title"] as? String ?? ""
        pullRequest.body = dictionary["body"] as? String ?? ""

        if let ownerDictionary = dictionary["user"] as? [String : AnyObject] {
            pullRequest.ownerLogin = ownerDictionary["login"] as? String ?? ""
            pullRequest.ownerAvatarUrl = ownerDictionary["avatar_url"] as? String ?? ""
        }
        if let createdAt = dictionary["created_at"] as? String {
            pullRequest.createdDate = dateFormatter.dateFromString(createdAt)
        }
        if let updatedAt = dictionary["updated_at"] as? String {
            pullRequest.updatedDate = dateFormatter.dateFromString(updatedAt)
        }
        
        pullRequest.url = dictionary["html_url"] as? String ?? ""
        pullRequest.status = dictionary["state"] as? String ?? "closed"
        
        return pullRequest
    }
    
}
