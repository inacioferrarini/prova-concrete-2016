import UIKit
import York

class ViewControllerManager: NSObject {
    
    func repositoryListTableViewController(appContext: AppContext!) -> RepositoryListTableViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let repositoryListTableViewController = storyBoard.instantiateViewControllerWithIdentifier("RepositoryListTableViewController") as! RepositoryListTableViewController
        repositoryListTableViewController.appContext = appContext
        return repositoryListTableViewController
    }
    
    func pullRequestListTableViewController(appContext: AppContext!) -> PullRequestListTableViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pullRequestListTableViewController = storyBoard.instantiateViewControllerWithIdentifier("PullRequestListTableViewController") as! PullRequestListTableViewController
        pullRequestListTableViewController.appContext = appContext
        return pullRequestListTableViewController
    }
    
}
