import UIKit

class PullRequestListTableViewController: BaseTableViewController {

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
                //            PullRequestTableViewCell
                print(" Table view cell presenter configure cell block ... \(entity)")
            }, cellReuseIdentifier: "PullRequestTableViewCell")
        
        let sortDescriptors:[NSSortDescriptor] = [] // TODO: update
        let context = self.appContext.coreDataStack.managedObjectContext
        let logger = appContext.logger
        
        let dataSource = FetcherDataSource<EntityPullRequest>(
            targetingTableView: self.tableView!,
            presenter: presenter,
            entityName: EntityRepository.entityName(),
            sortDescriptors: sortDescriptors,
            managedObjectContext: context,
            logger: logger)
        
        return dataSource
    }

}
