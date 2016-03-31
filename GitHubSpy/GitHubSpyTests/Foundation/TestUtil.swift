import XCTest

class TestUtil: XCTestCase {

    static let modelFileName = "DataSyncRules"
    static let databaseFileName = "DataSyncRulesDB"
    
    func createCoreDataStack() -> CoreDataStack {
        return CoreDataStack(modelFileName: TestUtil.modelFileName, databaseFileName: TestUtil.databaseFileName, logger: Logger())
    }
    
    func purgeDB(dbName:String) {
        if let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last {
            
            do {
                let url = applicationDocumentsDirectory.URLByAppendingPathComponent("\(dbName).sqlite")
                try! NSFileManager.defaultManager().removeItemAtURL(url)
            } catch {
                print(error)
            }
        }
    }
    
    func randomRuleName() -> String {
        return NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
    }
    
}
