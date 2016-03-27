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
                
                let cell = cell as! RepositoryTableViewCell
                cell.repositoryNameLabel.text = entity.name ?? ""
                cell.repositoryDescriptionLabel.text = entity.descriptionText ?? ""
                cell.branchCountLabel.text = "\(entity.forksCount ?? 0)"
                cell.starCountLabel.text = "\(entity.starsCount ?? 0)"
                
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
    
    override func createDelegate() -> UITableViewDelegate? {
        
        let itemSelectionBlock = { (indexPath:NSIndexPath) -> Void in
            if let dataSource = self.dataSource as? FetcherDataSource<EntityRepository> {
                let selectedValue = dataSource.objectAtIndexPath(indexPath)
                let ownerLogin = selectedValue.owner?.login ?? ""
                let repositoryName = selectedValue.name ?? ""

                print("Selected repository [\(repositoryName)] for Owner [\(ownerLogin)]")
                
            }
        }
        
        return TableViewBlockDelegate(itemSelectionBlock: itemSelectionBlock)
    }
    
}
