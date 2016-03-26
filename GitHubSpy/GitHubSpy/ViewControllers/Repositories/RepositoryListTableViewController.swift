import UIKit

class RepositoryListTableViewController: BaseTableViewController {

    // MARK: - BaseTableViewController override
    
    override func viewControllerTitle() -> String? {
        return NSLocalizedString("VC_REPOSITORY_LIST_TITLE", comment: "VC_REPOSITORY_LIST_TITLE")
    }
    
    override func shouldCheckTodayData() -> Bool {
        return false
    }
    
    override func syncDataWithServer() {
        self.syncDataComplete()
    }
    
    override func createDataSource() -> UITableViewDataSource? {
        
        let presenter = TableViewCellPresenter<UITableViewCell, EntityRepository>(
            configureCellBlock: { (cell: UITableViewCell, entity:EntityRepository) -> Void in
    //            RepositoryTableViewCell
                print(" Table view cell presenter configure cell block ... \(entity)")
            }, cellReuseIdentifier: "RepositoryTableViewCell")
        
        let sortDescriptors:[NSSortDescriptor] = [] // TODO: update
        let context = self.appContext.coreDataStack.managedObjectContext
        let logger = appContext.logger
        
        let dataSource = FetcherDataSource<EntityRepository>(
            targetingTableView: self.tableView!,
            presenter: presenter,
            entityName: EntityRepository.entityName(),
            sortDescriptors: sortDescriptors,
            managedObjectContext: context,
            logger: logger)
        
        return dataSource
    }
    
}
