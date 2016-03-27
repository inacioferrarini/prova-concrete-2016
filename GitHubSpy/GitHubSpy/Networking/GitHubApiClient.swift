import UIKit
import AFNetworking

class GitHubApiClient: NSObject {
    
//    https://api.github.com/search/repositories?q=language:Java&sort=stars&page=1
//    https://api.github.com/repos/<criador>/<repositório>/pulls
    
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
    
//    func getPullRequests(owner:String, repository:String, completion: (([PullRequest]?) -> Void)) {
//        
//    }
 
    
    
    
//    void (^successBlock)(id cell, id item) = ^(AFHTTPRequestOperation *operation, id responseObject) {
//    if (nil != completionBlock) {
//    completionBlock(YES, responseObject);
//    }
//    };
//    
//    void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
//    if (nil != completionBlock) {
//    completionBlock(NO, nil);
//    }
//    };
//    
//      NSURL *url = [self baseServiceUrl];
//      AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
//      NSString *targetUrl = @"/?t={movieName}&y=&plot=short&r=json";
//      // todo: fazer escape do nome
//      name = [name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    targetUrl = [targetUrl stringByReplacingOccurrencesOfString:@"{movieName}" withString:name];
//    
//    [manager GET:targetUrl parameters:nil success:successBlock failure:failureBlock];
    
    
}
