import XCTest

class TestUtil: XCTestCase {

    static let modelFileName = "DataSyncRules"
    static let databaseFileName = "DataSyncRulesDB"
    
    func createCoreDataStack() -> CoreDataStack {
        return CoreDataStack(modelFileName: TestUtil.modelFileName, databaseFileName: TestUtil.databaseFileName, logger: Logger())
    }
    
    func randomRuleName() -> String {
        return NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
    }
    
}
