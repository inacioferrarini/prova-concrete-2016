import UIKit
import York

class Routes: NSObject {
    
    func initialUrl() -> String {
        return "/"
    }
    
    func showPullRequestsUrl(owner:String, repositoryName:String, presentationMode: PresentationMode) -> String {
        let owner = owner.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let repositoryName = repositoryName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        if let owner = owner, let repositoryName = repositoryName {
            let values = [ ":owner": owner, ":repo": repositoryName]
            return PresentationPath(pattern: "/pr/:owner/:repo").replacingValues(values, mode: presentationMode)
        }
        
        return ""
    }

}
