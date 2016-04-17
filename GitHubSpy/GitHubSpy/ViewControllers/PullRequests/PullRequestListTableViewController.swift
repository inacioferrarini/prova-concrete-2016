import UIKit
import York

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
            let owner = repository.owner,
            let ownerName = owner.login {
        
                GitHubApiClient(appContext: self.appContext).getPullRequests(ownerName, repository: repository,
                    completionBlock: { (pullRequests: [EntityPullRequest]?) -> Void in
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
                         
        let presenter = TableViewCellPresenter<PullRequestTableViewCell, EntityPullRequest>(
            configureCellBlock: { (cell: PullRequestTableViewCell, entity:EntityPullRequest) -> Void in

                cell.pullRequestTitleLabel.text = entity.title ?? ""
                cell.pullRequestBodyLabel.text = entity.body ?? ""
                
                if let owner = entity.owner {
                    let placeHolderImage = UIImage(named: "default-avatar")!
                    cell.authorInfoView.userLoginLabel.text = owner.login ?? ""
                    cell.authorInfoView.userNameLabel.text = "\(owner.firstName ?? "") \(owner.lastName ?? "")"
                    if let url = owner.avatarUrl,
                        let avatarUrl = NSURL(string: url) {
                            cell.authorInfoView.userAvatarImage.sd_setImageWithURL(avatarUrl, placeholderImage: placeHolderImage)
                    }
                }
                
            }, cellReuseIdentifier: "PullRequestTableViewCell")
        
        let sortDescriptors:[NSSortDescriptor] = [] // TODO: update
        let context = self.appContext.coreDataStack.managedObjectContext
        let logger = appContext.logger
        
        let dataSource = FetcherDataSource<PullRequestTableViewCell, EntityPullRequest>(
            targetingTableView: self.tableView!,
            presenter: presenter,
            entityName: EntityPullRequest.simpleClassName(),
            sortDescriptors: sortDescriptors,
            managedObjectContext: context,
            logger: logger)
        
        if let repository = self.repository {
            dataSource.predicate = NSPredicate(format: "repository = %@", repository)
        }
        
        dataSource.refreshData()
        
        return dataSource
    }

    override func createDelegate() -> UITableViewDelegate? {
        
        let itemSelectionBlock = { (indexPath:NSIndexPath) -> Void in
            if let dataSource = self.dataSource as? FetcherDataSource<PullRequestTableViewCell, EntityPullRequest> {
                let selectedValue = dataSource.objectAtIndexPath(indexPath)
                if let url = selectedValue.url {
                    self.appContext.router.navigateExternal(url)
                }
            }
        }
        
        return TableViewBlockDelegate(tableView: self.tableView!, itemSelectionBlock: itemSelectionBlock, loadMoreDataBlock: nil)
    }
    
}
