import Foundation
import CoreData

extension EntityPullRequest {

    @NSManaged var body: String?
    @NSManaged var created: NSDate?
    @NSManaged var lastUpdated: NSDate?
    @NSManaged var title: String?
    @NSManaged var uid: NSNumber?
    @NSManaged var url: String?
    @NSManaged var status: String?
    @NSManaged var owner: EntityAuthor?
    @NSManaged var repository: EntityRepository?

}
