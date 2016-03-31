import XCTest

class EntitySyncHistoryTests: XCTestCase {
    
    func test_fetchEntityAutoSyncHistory_withEmptyName_mustReturnNil() {
        let coreDataStack = TestUtil().createCoreDataStack()
        let context = coreDataStack.managedObjectContext
        let sincHistory = EntitySyncHistory.fetchEntityAutoSyncHistoryByName("", inManagedObjectContext: context)
        XCTAssertNil(sincHistory)
    }
    
    func test_newEntityAutoSyncHistory_withEmptyName_mustReturnNil() {
        let coreDataStack = TestUtil().createCoreDataStack()
        let context = coreDataStack.managedObjectContext
        let sincHistory = EntitySyncHistory.entityAutoSyncHistoryByName("", lastExecutionDate: nil, inManagedObjectContext: context)
        XCTAssertNil(sincHistory)
    }
    
}
