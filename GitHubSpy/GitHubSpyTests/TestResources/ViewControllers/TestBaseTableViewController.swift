import UIKit
import GitHubSpy

class TestBaseTableViewController: BaseTableViewController {
    
    override func createDataSource() -> UITableViewDataSource? {
        let presenter = TableViewCellPresenter<UITableViewCell, EntitySyncHistory>(
            configureCellBlock: { (cell: UITableViewCell, entity:EntitySyncHistory) -> Void in
                
            }, cellReuseIdentifier: "TableViewCell")
        
        let sortDescriptors:[NSSortDescriptor] = []
        let context = self.appContext.coreDataStack.managedObjectContext
        let logger = appContext.logger
        
        let dataSource = FetcherDataSource<EntitySyncHistory>(
            targetingTableView: self.tableView!,
            presenter: presenter,
            entityName: EntitySyncHistory.entityName(),
            sortDescriptors: sortDescriptors,
            managedObjectContext: context,
            logger: logger)
        
        return dataSource
    }
    
    override func createDelegate() -> UITableViewDelegate? {
        let itemSelectionBlock = { (indexPath:NSIndexPath) -> Void in

        }
        return TableViewBlockDelegate(tableView: self.tableView!, itemSelectionBlock: itemSelectionBlock, loadMoreDataBlock: nil)
    }
    
}
