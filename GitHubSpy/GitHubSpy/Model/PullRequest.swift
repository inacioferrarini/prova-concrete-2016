import UIKit

class PullRequest: NSObject {

    class func fromArrayOfDictionaries(arrayOfDictionaries: [[String : AnyObject]]) -> [PullRequest] {
        var array = [PullRequest]()
        
        for dic in arrayOfDictionaries {
            array.append(self.fromDictionary(dic))
        }
        
        return array
    }
    
    
    class func fromDictionary(dictionary: [String : AnyObject]) -> PullRequest {
        let pullRequest = PullRequest()
        
        print ("fromDictionary \(dictionary)")
        
        return pullRequest
    }
    
}
