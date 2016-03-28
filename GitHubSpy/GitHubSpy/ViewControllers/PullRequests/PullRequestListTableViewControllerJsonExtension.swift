import Foundation

extension PullRequestListTableViewController {
    
    func processPullRequests(pullRequests: [PullRequest]) {
        for pullRequest in pullRequests {
            self.processPullRequest(pullRequest)
        }
    }
    
    func processPullRequest(pullRequest: PullRequest) {
        let ctx = self.appContext.coreDataStack.managedObjectContext
        
        if let repository = self.repository,
            let entityAuthor = repository.owner,
            let pullRequestUid = pullRequest.uid,
            let entityPullRequest = EntityPullRequest.entityPullRequestWithUid(pullRequestUid, owner: entityAuthor, repository: repository, inManagedObjectContext: ctx) {
                
                entityAuthor.login = pullRequest.ownerLogin
                entityAuthor.firstName = ""
                entityAuthor.lastName = ""
                entityAuthor.avatarUrl = pullRequest.ownerAvatarUrl
                
                entityPullRequest.title = pullRequest.title ?? ""
                entityPullRequest.body = pullRequest.body ?? ""
                entityPullRequest.created = pullRequest.createdDate
                entityPullRequest.lastUpdated = pullRequest.updatedDate
                entityPullRequest.url = pullRequest.url ?? ""
        }
    }    
    
}