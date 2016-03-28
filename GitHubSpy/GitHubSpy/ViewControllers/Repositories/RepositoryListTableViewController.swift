import UIKit

class RepositoryListTableViewController: BaseTableViewController {

    // MARK: - BaseTableViewController override
    
    override func viewControllerTitle() -> String? {
        return NSLocalizedString("VC_REPOSITORY_LIST_TITLE", comment: "VC_REPOSITORY_LIST_TITLE")
    }
    
    override func shouldCheckTodayData() -> Bool {
        return true
    }
    
    override func syncDataWithServer() {
        GitHubApiClient().getRepositories(atPage: 1,
            completionBlock: { (repositories:[Repository]?) -> Void in
                
                if let repositories = repositories {
                    self.processRepositories(repositories)
                }
                
                self.syncDataComplete()
            }) { (error: NSError) -> Void in
                self.appContext.logger.logError(error)
                self.syncDataComplete()
        }
    }
    
    func processRepositories(repositories: [Repository]) {
        for repository in repositories {
            self.processRepository(repository)
        }
    }
    
    func processRepository(repository: Repository) {
        let ctx = self.appContext.coreDataStack.managedObjectContext
        
        if let authorLogin = repository.ownerLogin,
            let entityAuthor = EntityAuthor.entityAuthorWithLogin(authorLogin, inManagedObjectContext: ctx),
            let entityRepositoryName = repository.name,
            let entityRepository = EntityRepository.entityRepositoryWithName(entityRepositoryName, owner: entityAuthor, inManagedObjectContext: ctx) {
                
                entityRepository.descriptionText = repository.descriptionText ?? ""
                entityRepository.forksCount = repository.forksCount ?? 0
                entityRepository.starsCount = repository.starsCount ?? 0
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
        
        return TableViewBlockDelegate(itemSelectionBlock: itemSelectionBlock)
    }
    
}
