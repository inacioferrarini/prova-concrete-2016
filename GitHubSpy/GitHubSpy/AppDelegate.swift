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
            let stack = CoreDataStack(logger: logger)
            let router = NavigationRouter(coreDataStack: stack, baseNavigationController: rootNavigationController, logger: logger)
            
            self.appContext = AppContext(navigationController: rootNavigationController,
                coreDataStack: stack,
                router: router,
                logger: logger)
            
            firstViewController.appContext = self.appContext
            
            router.registerRoutes()
        }
        
        return true
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

