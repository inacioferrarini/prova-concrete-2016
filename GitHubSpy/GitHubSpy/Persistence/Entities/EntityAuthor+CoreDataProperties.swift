import Foundation
import CoreData
import York

extension EntityAuthor {

    @NSManaged var login: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var avatarUrl: String?
    @NSManaged var repositories: NSSet?
    @NSManaged var pullRequests: NSSet?

}
