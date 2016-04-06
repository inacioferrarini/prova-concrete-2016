import XCTest
import CoreData
@testable import GitHubSpy

class EntityBaseSyncRulesTests: XCTestCase {

    func test_fetchEntityHourlySyncRule_withEmptyName_mustReturnNil() {
        let coreDataStack = TestUtil().appContext().coreDataStack
        let context = coreDataStack.managedObjectContext
        let basicSyncRules = EntityBaseSyncRules.fetchEntityBaseSyncRulesByName("", inManagedObjectContext: context)
        XCTAssertNil(basicSyncRules)
    }
    
    func test_shouldRunSyncRule_withEmptyName_mustReturnFalse() {
        let coreDataStack = TestUtil().appContext().coreDataStack
        let context = coreDataStack.managedObjectContext
        
        if let rule = NSEntityDescription.insertNewObjectForEntityForName(EntityBaseSyncRules.entityName(), inManagedObjectContext: context) as? EntityBaseSyncRules {
            let shouldRunSyncRule = rule.shouldRunSyncRuleWithName("", date: NSDate(), inManagedObjectContext: context)
            XCTAssertFalse(shouldRunSyncRule)
        }
    }
    
}
