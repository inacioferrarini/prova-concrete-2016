import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appContext: AppContext?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if let window = self.window {
            
            let rootNavigationController = window.rootViewController as! UINavigationController
            var firstViewController = rootNavigationController.topViewController as! AppContextAwareProtocol
            
            let logger = Logger()
            let stack = CoreDataStack(modelFileName: "GitHubSpy", databaseFileName: "GitHubSpy", logger: logger)
            let router = NavigationRouter(schema: "GitHubSpy", coreDataStack: stack, baseNavigationController: rootNavigationController, logger: logger)
            
            self.appContext = AppContext(navigationController: rootNavigationController,
                coreDataStack: stack,
                router: router,
                logger: logger)
            
            firstViewController.appContext = self.appContext
            
            router.registerRoutes()
            
//self.createTestDatabase()
        }
        
        return true
    }

    func createTestDatabase() {
        
        let ctx = self.appContext!.coreDataStack.managedObjectContext
        
        if let author = EntityAuthor.entityAuthorWithLogin("User0", inManagedObjectContext: ctx) {
            if let repo0 = EntityRepository.entityRepositoryWithName("Repo0", owner: author, inManagedObjectContext: ctx) {
                EntityPullRequest.entityPullRequestWithUid(12, owner: author, repository: repo0, inManagedObjectContext: ctx)
                EntityPullRequest.entityPullRequestWithUid(16, owner: author, repository: repo0, inManagedObjectContext: ctx)
                EntityPullRequest.entityPullRequestWithUid(90, owner: author, repository: repo0, inManagedObjectContext: ctx)
            }
            if let repo1 = EntityRepository.entityRepositoryWithName("Repo1", owner: author, inManagedObjectContext: ctx) {
                EntityPullRequest.entityPullRequestWithUid(100, owner: author, repository: repo1, inManagedObjectContext: ctx)
                EntityPullRequest.entityPullRequestWithUid(200, owner: author, repository: repo1, inManagedObjectContext: ctx)
                EntityPullRequest.entityPullRequestWithUid(300, owner: author, repository: repo1, inManagedObjectContext: ctx)
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

