import UIKit

class PullRequestListTableViewController: BaseTableViewController {

    var repository:EntityRepository?
    
    // MARK: - BaseTableViewController override
    
    override func viewControllerTitle() -> String? {
        return NSLocalizedString("VC_PULL_REQUEST_LIST_TITLE", comment: "VC_PULL_REQUEST_LIST_TITLE")
    }
    
    override func shouldCheckTodayData() -> Bool {
        return false
    }
    
    override func syncDataWithServer() {
        self.syncDataComplete()
    }
    
    override func createDataSource() -> UITableViewDataSource? {
        
        let presenter = TableViewCellPresenter<UITableViewCell, EntityPullRequest>(
            configureCellBlock: { (cell: UITableViewCell, entity:EntityPullRequest) -> Void in

                let cell = cell as! PullRequestTableViewCell
                cell.pullRequestTitleLabel.text = entity.title ?? ""
                cell.pullRequestBodyLabel.text = entity.body ?? ""
//                cell.authorInfoView
                
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
        
        return TableViewBlockDelegate(itemSelectionBlock: itemSelectionBlock)
    }
    
}
