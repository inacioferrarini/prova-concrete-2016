import UIKit

class Routes: NSObject {
    
    func initialUrl() -> String {
        return "/"
    }
    
    func showPullRequestsUrl(owner:String, repositoryName:String) -> String {
        
        let owner = owner.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let repositoryName = repositoryName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        if let owner = owner,
           let repositoryName = repositoryName {
            return "/pr" + "/" + owner + "/" + repositoryName
        }
    
        return ""
    }
    
}
