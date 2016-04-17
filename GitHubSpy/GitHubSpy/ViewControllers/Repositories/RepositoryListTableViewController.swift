import UIKit
import SDWebImage
import York

class RepositoryListTableViewController: BaseTableViewController {

    private var lastFetchedPage = 1
    
    // MARK: - BaseTableViewController override
    
    override func viewControllerTitle() -> String? {
        return NSLocalizedString("VC_REPOSITORY_LIST_TITLE", comment: "VC_REPOSITORY_LIST_TITLE")
    }
        
    override func performDataSync() {
        
        self.lastFetchedPage = self.lastFetchedPage + 1
        
        GitHubApiClient(appContext: self.appContext).getRepositories(atPage: self.lastFetchedPage,
            completionBlock: { (repositories:[EntityRepository]?) -> Void in
                self.appContext.coreDataStack.saveContext()
                self.dataSyncCompleted()
            }) { (error: NSError) -> Void in
                self.appContext.logger.logError(error)
                self.appContext.coreDataStack.saveContext()
                self.dataSyncCompleted()
        }
    }
    
    override func createDataSource() -> UITableViewDataSource? {
        
        let presenter = TableViewCellPresenter<RepositoryTableViewCell, EntityRepository> (
            configureCellBlock: { (cell: RepositoryTableViewCell, entity:EntityRepository) -> Void in
                
                //let cell = cell as! RepositoryTableViewCell
                cell.repositoryNameLabel.text = entity.name ?? ""
                cell.repositoryDescriptionLabel.text = entity.descriptionText ?? ""
                cell.branchCountLabel.text = "\(entity.forksCount ?? 0)"
                cell.starCountLabel.text = "\(entity.starsCount ?? 0)"

                if let owner = entity.owner {
                    let placeHolderImage = UIImage(named: "default-avatar")!
                    cell.authorInfoView.userLoginLabel.text = owner.login ?? ""
                    cell.authorInfoView.userNameLabel.text = "\(owner.firstName ?? "") \(owner.lastName ?? "")"
                    if let url = owner.avatarUrl,
                        let avatarUrl = NSURL(string: url) {
                            cell.authorInfoView.userAvatarImage.sd_setImageWithURL(avatarUrl, placeholderImage: placeHolderImage)
                    }
                }
                
            }, cellReuseIdentifier: "RepositoryTableViewCell")
        
        let sortDescriptors:[NSSortDescriptor] = [] // TODO: update
        let context = self.appContext.coreDataStack.managedObjectContext
        let logger = appContext.logger
        
        let dataSource = FetcherDataSource<RepositoryTableViewCell, EntityRepository>(
            targetingTableView: self.tableView!,
            presenter: presenter,
            entityName: EntityRepository.simpleClassName(),
            sortDescriptors: sortDescriptors,
            managedObjectContext: context,
            logger: logger)
        
        dataSource.refreshData()
        
        return dataSource
    }
    
    override func createDelegate() -> UITableViewDelegate? {
        
        let itemSelectionBlock = { (indexPath:NSIndexPath) -> Void in
            if let dataSource = self.dataSource as? FetcherDataSource<RepositoryTableViewCell, EntityRepository> {
                let selectedValue = dataSource.objectAtIndexPath(indexPath)
                let ownerLogin = selectedValue.owner?.login ?? ""
                let repositoryName = selectedValue.name ?? ""
                
                let route = Routes().showPullRequestsUrl(ownerLogin, repositoryName: repositoryName)
                self.appContext.router.navigateInternal(route)
            }
        }
        
        let loadMoreDataBlock = { () -> Void in
            self.performDataSync()
        }
        
        return TableViewBlockDelegate(tableView: self.tableView!, itemSelectionBlock: itemSelectionBlock, loadMoreDataBlock: loadMoreDataBlock)
    }
    
}
