import UIKit

enum SyncRule {
    case Hourly(Int)
    case Daily(Int)
}

class DataSyncRules: NSObject {
    
    // MARK: - Properties
    
    let coreDataStack: CoreDataStack
    
    
    // MARK: - Initialization
    
    init(coreDataStack: CoreDataStack) {    // rules: [String, SyncRule]
        self.coreDataStack = coreDataStack
        super.init()
    }
    
    
    // MARK: - Public Methods
    
    func addSyncRule(ruleName: String, rule: SyncRule) {
        let context = self.coreDataStack.managedObjectContext
        switch rule {
        case let .Hourly(hours):
            EntityHourlySyncRule.entityHourlySyncRuleByName(ruleName, hours: hours, inManagedObjectContext: context)
        case let .Daily(days):
            EntityDailySyncRule.entityDailySyncRuleByName(ruleName, days: days, inManagedObjectContext: context)
        }
        self.coreDataStack.saveContext()
    }
    
    func shouldPerformSyncRule(ruleName: String, atDate date:NSDate) -> Bool {
        let context = self.coreDataStack.managedObjectContext
        if let rule = EntityBaseSyncRules.fetchEntityBaseSyncRulesByName(ruleName, inManagedObjectContext: context) {
            return rule.shouldRunSyncRuleWithName(ruleName, date: date, inManagedObjectContext: context)
        }
        
        return false
    }
    
    func updateSyncRuleHistoryExecutionTime(ruleName: String, lastExecutionDate: NSDate) {
        let context = self.coreDataStack.managedObjectContext
        if let rule = EntitySyncHistory.fetchEntityAutoSyncHistoryByName(ruleName, inManagedObjectContext: context) {
            rule.lastExecutionDate = lastExecutionDate
        } else {
            EntitySyncHistory.entityAutoSyncHistoryByName(ruleName,
                lastExecutionDate: lastExecutionDate, inManagedObjectContext: context)
        }
    }
    
}
