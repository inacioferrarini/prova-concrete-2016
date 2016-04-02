import UIKit

class PullRequestListTableViewController: BaseTableViewController {

    var repository:EntityRepository?
    @IBOutlet weak var openPRCountLabel: UILabel!
    @IBOutlet weak var closedPRCountLabel: UILabel!
    
    // MARK: - BaseTableViewController override
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)        
        let ctx = self.appContext.coreDataStack.managedObjectContext
        self.updateOpenPRCount(self.repository?.openPullRequestCount(inManagedObjectContext: ctx) ?? 0)
        self.updateClosedPRCount(self.repository?.closedPullRequestCount(inManagedObjectContext: ctx) ?? 0)
    }

    func updateOpenPRCount(openPR:Int) {
        let text = NSLocalizedString("VC_PULL_REQUEST_LIST_OPEN_PR_COUNT", comment: "VC_PULL_REQUEST_LIST_OPEN_PR_COUNT")
        self.openPRCountLabel.text = "\(openPR)\(text)"
    }

    func updateClosedPRCount(closedPR:Int) {
        let text = NSLocalizedString("VC_PULL_REQUEST_LIST_CLOSED_PR_COUNT", comment: "VC_PULL_REQUEST_LIST_CLOSED_PR_COUNT")
        self.closedPRCountLabel.text = "\(closedPR)\(text)"
    }
    
    override func viewControllerTitle() -> String? {
        return NSLocalizedString("VC_PULL_REQUEST_LIST_TITLE", comment: "VC_PULL_REQUEST_LIST_TITLE")
    }
    
    override func performDataSync() {
        
        if let repository = self.repository,
            let repositoryName = repository.name,
            let owner = repository.owner,
            let ownerName = owner.login {
        
                GitHubApiClient().getPullRequests(ownerName, repository: repositoryName,
                    completionBlock: { (pullRequests: [PullRequest]?) -> Void in
                        
                        if let pullRequests = pullRequests {
                            self.processPullRequests(pullRequests)
                        }
                        
                        self.appContext.coreDataStack.saveContext()

                        let ctx = self.appContext.coreDataStack.managedObjectContext
                        self.updateOpenPRCount(self.repository?.openPullRequestCount(inManagedObjectContext: ctx) ?? 0)
                        self.updateClosedPRCount(self.repository?.closedPullRequestCount(inManagedObjectContext: ctx) ?? 0)
                        
                        self.dataSyncCompleted()
                    }, errorHandlerBlock: { (error: NSError) -> Void in
                        self.appContext.logger.logError(error)
                        self.appContext.coreDataStack.saveContext()
                        self.dataSyncCompleted()
                })
        }
        
    }
       
    override func createDataSource() -> UITableViewDataSource? {
        
        let presenter = TableViewCellPresenter<UITableViewCell, EntityPullRequest>(
            configureCellBlock: { (cell: UITableViewCell, entity:EntityPullRequest) -> Void in

                let cell = cell as! PullRequestTableViewCell
                cell.pullRequestTitleLabel.text = entity.title ?? ""
                cell.pullRequestBodyLabel.text = entity.body ?? ""
                
                if let owner = entity.owner {
                    let placeHolderImage = UIImage(named: "git star")!
                    cell.authorInfoView.userLoginLabel.text = owner.login ?? ""
                    cell.authorInfoView.userNameLabel.text = "\(owner.firstName ?? "") \(owner.lastName ?? "")"                    
                    self.smallUserPhotoForUserUid(owner.login ?? "", url: owner.avatarUrl ?? "",
                        placeHolderImage: placeHolderImage, targetImageView: cell.authorInfoView.userAvatarImage)
                }
                
            }, cellReuseIdentifier: "PullRequestTableViewCell")
        
        let sortDescriptors:[NSSortDescriptor] = [] // TODO: update
        let context = self.appContext.coreDataStack.managedObjectContext
        let logger = appContext.logger
        
        let dataSource = FetcherDataSource<EntityPullRequest>(
            targetingTableView: self.tableView!,
            presenter: presenter,
            entityName: EntityPullRequest.entityName(),
            sortDescriptors: sortDescriptors,
            managedObjectContext: context,
            logger: logger)
        
        if let repository = self.repository {
            dataSource.predicate = NSPredicate(format: "repository = %@", repository)
        }
        
        return dataSource
    }

    override func createDelegate() -> UITableViewDelegate? {
        
        let itemSelectionBlock = { (indexPath:NSIndexPath) -> Void in
            if let dataSource = self.dataSource as? FetcherDataSource<EntityPullRequest> {
                let selectedValue = dataSource.objectAtIndexPath(indexPath)
                if let url = selectedValue.url {
                    self.appContext.router.navigateExternal(url)
                }
            }
        }
        
        return TableViewBlockDelegate(tableView: self.tableView!, itemSelectionBlock: itemSelectionBlock, loadMoreDataBlock: nil)
    }
    
}
