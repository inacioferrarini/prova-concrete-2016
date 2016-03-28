import UIKit

class RepositoryListTableViewController: BaseTableViewController {

    private var lastFetchedPage = 1
    
    // MARK: - BaseTableViewController override
    
    override func viewControllerTitle() -> String? {
        return NSLocalizedString("VC_REPOSITORY_LIST_TITLE", comment: "VC_REPOSITORY_LIST_TITLE")
    }
    
    override func shouldCheckTodayData() -> Bool {
        return true
    }
    
    override func syncDataWithServer() {
        
        self.lastFetchedPage = self.lastFetchedPage + 1
        
        GitHubApiClient().getRepositories(atPage: self.lastFetchedPage,
            completionBlock: { (repositories:[Repository]?) -> Void in
                
                if let repositories = repositories {
                    self.processRepositories(repositories)
                }
                
                self.appContext.coreDataStack.saveContext()
                self.syncDataComplete()
            }) { (error: NSError) -> Void in
                self.appContext.logger.logError(error)
                self.appContext.coreDataStack.saveContext()
                self.syncDataComplete()
        }
    }
    
    override func createDataSource() -> UITableViewDataSource? {
        
        let presenter = TableViewCellPresenter<UITableViewCell, EntityRepository>(
            configureCellBlock: { (cell: UITableViewCell, entity:EntityRepository) -> Void in
                
                let cell = cell as! RepositoryTableViewCell
                cell.repositoryNameLabel.text = entity.name ?? ""
                cell.repositoryDescriptionLabel.text = entity.descriptionText ?? ""
                cell.branchCountLabel.text = "\(entity.forksCount ?? 0)"
                cell.starCountLabel.text = "\(entity.starsCount ?? 0)"

                if let owner = entity.owner {
                    let placeHolderImage = UIImage(named: "git star")!
                    cell.authorInfoView.userLoginLabel.text = owner.login ?? ""
                    cell.authorInfoView.userNameLabel.text = "\(owner.firstName ?? "") \(owner.lastName ?? "")"
                    self.smallUserPhotoForUserUid(owner.login ?? "", url: owner.avatarUrl ?? "",
                        placeHolderImage: placeHolderImage, targetImageView: cell.authorInfoView.userAvatarImage)
                }
                
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
                
                let route = Routes().showPullRequestsUrl(ownerLogin, repositoryName: repositoryName)
                self.appContext.router.navigateInternal(route)
            }
        }
        
        let loadMoreDataBlock = { () -> Void in
            self.syncDataWithServer()
        }
        
        return TableViewBlockDelegate(tableView: self.tableView!, itemSelectionBlock: itemSelectionBlock, loadMoreDataBlock: loadMoreDataBlock)
//        return TableViewBlockDelegate(tableView: self.tableView!, itemSelectionBlock: itemSelectionBlock, loadMoreDataBlock: 
    }
    
}
