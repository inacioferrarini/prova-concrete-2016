import UIKit
import AFNetworking
import EasyMapping

class GitHubApiClient: NSObject {
    
    let rootUrl = "https://api.github.com/"
    let appContext:AppContext
    
    init(appContext:AppContext) {
        self.appContext = appContext
        super.init()
    }
    
    func getRepositories(atPage page:Int, completionBlock: (([EntityRepository]?) -> Void), errorHandlerBlock: ((NSError) -> Void)) {

        let successBlock = { (dataTask: NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            if let dictionary = responseObject as? [String : AnyObject] {
                if let repoDictionaryArray = dictionary["items"] as? [[String : AnyObject]] {
                    let context = self.appContext.coreDataStack.managedObjectContext
                    let repositories = EKManagedObjectMapper.arrayOfObjectsFromExternalRepresentation(repoDictionaryArray,
                        withMapping: MapperManager.entityRepositoryObjectMapping(),
                        inManagedObjectContext: context) as? [EntityRepository]
                    self.appContext.coreDataStack.saveContext()
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
            manager.GET(targetUrl, parameters: nil, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    
    
    func getPullRequests(owner:String, repository:EntityRepository, completionBlock: (([EntityPullRequest]?) -> Void), errorHandlerBlock: ((NSError) -> Void)) {
        
        let successBlock = { (dataTask: NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            if let dictionaryArray = responseObject as? [[String : AnyObject]] {
                let context = self.appContext.coreDataStack.managedObjectContext
                let pullRequests = EKManagedObjectMapper.arrayOfObjectsFromExternalRepresentation(dictionaryArray,
                    withMapping: MapperManager.entityPullRequestObjectMapping(repository), inManagedObjectContext: context) as? [EntityPullRequest]
                self.appContext.coreDataStack.saveContext()
                
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
                .stringByReplacingOccurrencesOfString("{:repository}", withString: repository.name!)
            manager.GET(targetUrl, parameters: nil, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    
}
