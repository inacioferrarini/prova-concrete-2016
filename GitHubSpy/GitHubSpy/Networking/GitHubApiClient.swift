import UIKit
import AFNetworking

class GitHubApiClient: NSObject {
    
    let rootUrl = "https://api.github.com/"
    
    func getRepositories(atPage page:Int, completionBlock: (([Repository]?) -> Void), errorHandlerBlock: ((NSError) -> Void)) {

        let successBlock = { (dataTask: NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            if let dictionary = responseObject as? [String : AnyObject] {
                if let repoDictionaryArray = dictionary["items"] as? [[String : AnyObject]] {
                    let repositories = Repository.fromArrayOfDictionaries(repoDictionaryArray)
                    completionBlock(repositories)
                }
            }
        }
        
        let failureBlock = { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            errorHandlerBlock(error)
        }
        
        if let url = NSURL(string: rootUrl) {
            let manager = AFHTTPSessionManager(baseURL: url)
            let targetUrl = "search/repositories?q=language:Java&sort=stars&page={:page}"
                        .stringByReplacingOccurrencesOfString("{:page}", withString: "\(page)")
            manager.GET(targetUrl, parameters: nil, success: successBlock, failure: failureBlock)
        }
    }
    
    
    func getPullRequests(owner:String, repository:String, completionBlock: (([PullRequest]?) -> Void), errorHandlerBlock: ((NSError) -> Void)) {
        
        let successBlock = { (dataTask: NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            if let dictionaryArray = responseObject as? [[String : AnyObject]] {
                let pullRequests = PullRequest.fromArrayOfDictionaries(dictionaryArray)
                completionBlock(pullRequests)
            }
        }
        
        let failureBlock = { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            errorHandlerBlock(error)
        }
        
        if let url = NSURL(string: rootUrl) {
            let manager = AFHTTPSessionManager(baseURL: url)
            let targetUrl = "repos/{:owner}/{:repository}/pulls?state=all"
                .stringByReplacingOccurrencesOfString("{:owner}", withString: owner)
                .stringByReplacingOccurrencesOfString("{:repository}", withString: repository)
            manager.GET(targetUrl, parameters: nil, success: successBlock, failure: failureBlock)
        }
    }
    
}
