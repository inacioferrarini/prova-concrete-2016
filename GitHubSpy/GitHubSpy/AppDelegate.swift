import UIKit
import CoreData
import York

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appContext: AppContext?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if let window = self.window {
            
            let rootNavigationController = window.rootViewController as! UINavigationController
            var firstViewController = rootNavigationController.topViewController as! AppContextAwareProtocol
            
            let appBundle = NSBundle(forClass: self.dynamicType)
            let podBundle = NSBundle(forClass: DataSyncRules.self)
            let logger = Logger()
            let stack = CoreDataStack(modelFileName: "GitHubSpy", databaseFileName: "GitHubSpy", logger: logger, bundle: appBundle)
            let router = NavigationRouter(schema: "GitHubSpy", logger: logger)
            let syncRulesStack = CoreDataStack(modelFileName: "DataSyncRules", databaseFileName: "DataSyncRules", logger: logger, bundle: podBundle)
            let syncRules = DataSyncRules(coreDataStack: syncRulesStack)
            
            self.appContext = AppContext(navigationController: rootNavigationController,
                coreDataStack: stack,
                syncRules: syncRules,
                router: router,
                logger: logger)
            
            firstViewController.appContext = self.appContext
            router.registerRoutes(self.createNavigationRoutes())
            
            self.addSyncRules(syncRules)
// self.createTestDatabase()
        }
        
        return true
    }
    
    func createNavigationRoutes() -> [RoutingElement] {
        
        var routes = [RoutingElement]()
        
        routes.append(RoutingElement(pattern: "/", handler: { (params: [NSObject : AnyObject]) -> Bool in
            print("Showing root ... ")
            return true
        }))
    
        routes.append(RoutingElement(pattern: "/pr/:owner/:repo", handler: { (params: [NSObject : AnyObject]) -> Bool in
            guard let owner = params["owner"] as? String else { return false }
            guard let repository = params["repo"] as? String else { return false }
            
            if let appContext = self.appContext {
                let context = appContext.coreDataStack.managedObjectContext
                let viewController = ViewControllerManager().pullRequestListTableViewController(appContext)
                
                if let owner = EntityAuthor.entityAuthorWithLogin(owner, inManagedObjectContext: context),
                    let repository = EntityRepository.entityRepositoryWithName(repository, owner: owner, inManagedObjectContext: context) {
                        viewController.repository = repository
                }
                appContext.navigationController.pushViewController(viewController, animated: true)
            }
            
            return true
        }))
        
        return routes
    }
    
    func addSyncRules(syncRules: DataSyncRules) {
        syncRules.addSyncRule(RepositoryListTableViewController.simpleClassName(), rule: .Hourly(3))
        syncRules.addSyncRule(PullRequestListTableViewController.simpleClassName(), rule: .Hourly(3))
    }
    
    func createTestDatabase() {
        
        let ctx = self.appContext!.coreDataStack.managedObjectContext
        
        if let author = EntityAuthor.entityAuthorWithLogin("User0", inManagedObjectContext: ctx) {
            if let repo0 = EntityRepository.entityRepositoryWithName("Repo 0", owner: author, inManagedObjectContext: ctx) {
                repo0.descriptionText = "asd asd asd asda sd asdasdasdasda sdasda sd asdasd asd asd asdasdasdasda sda sda sda sdasd asd asd asds "
                repo0.forksCount = 1250
                repo0.starsCount = 350
                
                if let pr = EntityPullRequest.entityPullRequestWithUid(12, owner: author, repository: repo0, inManagedObjectContext: ctx) {
                    pr.title = "Pull Request asdasdaasdasd"
                    pr.body = "PR Body asdas dasd asda sdasdasddas"
                    pr.url = "https://github.com/elastic/elasticsearch/pull/17351"
                }
                if let pr = EntityPullRequest.entityPullRequestWithUid(16, owner: author, repository: repo0, inManagedObjectContext: ctx) {
                    pr.title = "Pull Request asdasdaasdasd"
                    pr.body = "PR Body asdas dasd asda sdasdasddas"
                    pr.url = "https://github.com/elastic/elasticsearch/pull/17351"
                }
                if let pr = EntityPullRequest.entityPullRequestWithUid(90, owner: author, repository: repo0, inManagedObjectContext: ctx) {
                    pr.title = "Pull Request asdasdaasdasd"
                    pr.body = "PR Body asdas dasd asda sdasdasddas"
                    pr.url = "https://github.com/elastic/elasticsearch/pull/17351"
                }
            }
            if let repo1 = EntityRepository.entityRepositoryWithName("Repo 1", owner: author, inManagedObjectContext: ctx) {
                repo1.descriptionText = "asd asd asd asda sd asdasdasdasda sdasda sd asdasd asd asd aasdasdasdasdasdasdasd asdasdsadasdadsasd"
                repo1.forksCount = 25
                repo1.starsCount = 1350

                if let pr = EntityPullRequest.entityPullRequestWithUid(100, owner: author, repository: repo1, inManagedObjectContext: ctx) {
                    pr.title = "Pull Request asdasdaasdasd"
                    pr.body = "PR Body asdas dasd asda sdasdasddas"
                    pr.url = "https://github.com/elastic/elasticsearch/pull/17351"
                }
                if let pr = EntityPullRequest.entityPullRequestWithUid(200, owner: author, repository: repo1, inManagedObjectContext: ctx) {
                    pr.title = "Pull Request asdasdaasdasd"
                    pr.body = "PR Body asdas dasd asda sdasdasddas"
                    pr.url = "https://github.com/elastic/elasticsearch/pull/17351"
                }
                if let pr = EntityPullRequest.entityPullRequestWithUid(300, owner: author, repository: repo1, inManagedObjectContext: ctx) {
                    pr.title = "Pull Request asdasdaasdasd"
                    pr.body = "PR Body asdas dasd asda sdasdasddas"
                    pr.url = "https://github.com/elastic/elasticsearch/pull/17351"
                }
                if let pr = EntityPullRequest.entityPullRequestWithUid(400, owner: author, repository: repo1, inManagedObjectContext: ctx) {
                    pr.title = "Pull Request asdasdaasdasd"
                    pr.body = "PR Body asdas dasd asda sdasdasddas"
                    pr.url = "https://github.com/elastic/elasticsearch/pull/17351"
                }
            }
        }
        
        self.appContext!.coreDataStack.saveContext()
        
    }
    
    // MARK: - Deep Linking Navigation
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        if let appContext = self.appContext {
            return appContext.router.dispatch(url)
        }
        
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        
        if let url = userActivity.webpageURL,
            let appContext = self.appContext {
            return appContext.router.dispatch(url)
        }
        
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        
        if let appContext = self.appContext {
            appContext.coreDataStack.saveContext()
        }
        
    }

}

