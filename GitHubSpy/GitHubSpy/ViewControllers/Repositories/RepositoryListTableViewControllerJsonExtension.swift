import Foundation

extension RepositoryListTableViewController {
 
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
                
                entityAuthor.login = repository.ownerLogin
                entityAuthor.firstName = ""
                entityAuthor.lastName = ""
                entityAuthor.avatarUrl = repository.ownerAvatarUrl
                
                entityRepository.descriptionText = repository.descriptionText ?? ""
                entityRepository.forksCount = repository.forksCount ?? 0
                entityRepository.starsCount = repository.starsCount ?? 0
        }
    }
    
}