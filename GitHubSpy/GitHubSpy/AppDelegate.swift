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
            let logger = Logger(logProvider: AppLogProvider())
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
        }
        
        return true
    }
        
    func createNavigationRoutes() -> [RoutingElement] {

        var routes = [RoutingElement]()

        routes.append(RoutingElement(path: PresentationPath(pattern: "/"), handler: { (params: [NSObject : AnyObject]) -> Bool in
            print("Showing root ... ")
            return true
        }))

        routes.append(RoutingElement(path: PresentationPath(pattern: "/pr/:owner/:repo"), handler: { (params: [NSObject : AnyObject]) -> Bool in
            guard let owner = params["owner"] as? String else { return false }
            guard let repository = params["repo"] as? String else { return false }
            
            let presentationMode = PresentationPath.presentationMode(params)
            if let appContext = self.appContext {
                let context = appContext.coreDataStack.managedObjectContext
                let viewController = ViewControllerManager().pullRequestListTableViewController(appContext)

                if let owner = EntityAuthor.entityAuthorWithLogin(owner, inManagedObjectContext: context),
                    let repository = EntityRepository.entityRepositoryWithName(repository, owner: owner, inManagedObjectContext: context) {
                        viewController.repository = repository
                }
                appContext.navigationController.presentViewController(viewController, animated: true, presentationMode: presentationMode)
            }

            return true
        }))

        return routes
    }

    func addSyncRules(syncRules: DataSyncRules) {
        syncRules.addSyncRule(RepositoryListTableViewController.simpleClassName(), rule: .Hourly(3))
        syncRules.addSyncRule(PullRequestListTableViewController.simpleClassName(), rule: .Hourly(3))
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

