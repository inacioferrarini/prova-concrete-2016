import Foundation
import CoreData

extension EntityPullRequest {

    @NSManaged var title: String?
    @NSManaged var body: String?
    @NSManaged var created: NSDate?
    @NSManaged var lastUpdated: NSDate?
    @NSManaged var url: String?
    @NSManaged var uid: NSNumber?
    @NSManaged var owner: EntityAuthor?
    @NSManaged var repository: EntityRepository?

}
