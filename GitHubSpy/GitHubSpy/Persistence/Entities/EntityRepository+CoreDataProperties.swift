import Foundation
import CoreData
import York

extension EntityRepository {

    @NSManaged var name: String?
    @NSManaged var descriptionText: String?
    @NSManaged var forksCount: NSNumber?
    @NSManaged var starsCount: NSNumber?
    @NSManaged var owner: EntityAuthor?
    @NSManaged var pullRequests: NSSet?

}
