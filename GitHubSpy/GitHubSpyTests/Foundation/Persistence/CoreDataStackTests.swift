import XCTest
@testable import GitHubSpy

class CoreDataStackTests: XCTestCase {
    
    func test_saveContext_mustThrowException() {
        let coreDataStack = TestUtil().createCoreDataStack()
        let ctx = coreDataStack.managedObjectContext
        let ruleName = TestUtil().randomRuleName()
        if let testEntity = EntitySyncHistory.entityAutoSyncHistoryByName(ruleName, lastExecutionDate: nil, inManagedObjectContext: ctx) {
            testEntity.ruleName = nil
        }
        coreDataStack.saveContext()
    }
    
}
