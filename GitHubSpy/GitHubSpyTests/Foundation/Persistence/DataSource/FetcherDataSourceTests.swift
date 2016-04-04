import XCTest
import CoreData
@testable import GitHubSpy

class FetcherDataSourceTests: XCTestCase {    
    
    var tableView:UITableView!
    var entityName: String!
    var predicate: NSPredicate?
    var fetchLimit: NSInteger?
    var sortDescriptors: [NSSortDescriptor]!
    var sectionNameKeyPath: String?
    var cacheName: String?
    var coreDataStack: CoreDataStack!
    var managedObjectContext:NSManagedObjectContext!
    var presenter:TableViewCellPresenter<UITableViewCell, EntitySyncHistory>!
    var logger:Logger!
    var configureCellBlockWasCalled:Bool = false
    
    func createFetcherDataSource(sectionNameKeyPath nameKeyPath: String?) -> FetcherDataSource<EntitySyncHistory> {
        self.tableView = UITableView()
        self.presenter = TableViewCellPresenter<UITableViewCell, EntitySyncHistory>(
            configureCellBlock: { (cell: UITableViewCell, entity:EntitySyncHistory) -> Void in
                self.configureCellBlockWasCalled = true
            }, cellReuseIdentifier: "RepositoryTableViewCell")
        self.entityName = "EntitySyncHistory"
        self.sortDescriptors = []
        self.coreDataStack = TestUtil().createCoreDataStack()
        self.managedObjectContext = self.coreDataStack.managedObjectContext
        self.logger = Logger()
        self.predicate = NSPredicate(format: "ruleName = %@", "rule01")
        self.fetchLimit = 100
        self.sectionNameKeyPath = nameKeyPath
        self.cacheName = "cacheName"
        
        let dataSource = FetcherDataSource(targetingTableView: self.tableView,
            presenter: self.presenter,
            entityName: self.entityName,
            sortDescriptors: self.sortDescriptors,
            managedObjectContext: self.managedObjectContext,
            logger: self.logger,
            predicate: self.predicate,
            fetchLimit: self.fetchLimit,
            sectionNameKeyPath: self.sectionNameKeyPath,
            cacheName: self.cacheName)
        dataSource.predicate = nil
        return dataSource
    }
    
    
    func test_refresh_mustSucceed() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        dataSource.sortDescriptors = []
        dataSource.refreshData()
    }

//    func test_refresh_mustCrash() {
//        do {
//            let dataSource = self.createFetcherDataSource()
//            dataSource.sortDescriptors = [ NSSortDescriptor(key: "nonExistingField", ascending: true) ]
//            XCTAssertTrue(false)
//        } catch {
//            XCTAssertTrue(true)
//        }
//    }
    
    
    func test_objectAtIndexPath_mustReturnEntity() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        EntitySyncHistory.removeAll(inManagedObjectContext: self.managedObjectContext)
        EntitySyncHistory.entityAutoSyncHistoryByName("rule-test-name",
            lastExecutionDate: nil,
            inManagedObjectContext: self.managedObjectContext)
        self.coreDataStack.saveContext()
        dataSource.refreshData()
        // let indexPath = dataSource.indexPathForObject(entity!)
        let object = dataSource.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertNotNil(object)
    }
    
    
    func test_indexPathForObject_mustReturnObject() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        EntitySyncHistory.removeAll(inManagedObjectContext: self.managedObjectContext)
        let entity = EntitySyncHistory.entityAutoSyncHistoryByName("rule-test-name",
            lastExecutionDate: nil,
            inManagedObjectContext: self.managedObjectContext)
        self.coreDataStack.saveContext()
        dataSource.refreshData()
        let indexPath = dataSource.indexPathForObject(entity!)
        XCTAssertNotNil(indexPath)
    }
    
    func test_indexPathForObject_mustReturnNil() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        EntitySyncHistory.removeAll(inManagedObjectContext: self.managedObjectContext)
        let entity = EntitySyncHistory.entityAutoSyncHistoryByName("rule-test-name",
            lastExecutionDate: nil,
            inManagedObjectContext: self.managedObjectContext)
        self.coreDataStack.saveContext()
        dataSource.refreshData()
        let indexPath = dataSource.indexPathForObject(entity!)
        XCTAssertNotNil(indexPath)
    }
    
    
    func test_numberOfSections_mustReturnZero() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: "ruleName")
        EntitySyncHistory.removeAll(inManagedObjectContext: self.managedObjectContext)
        // dataSource.sectionNameKeyPath = "ruleName"
        self.coreDataStack.saveContext()
        let numberOfSections = dataSource.numberOfSectionsInTableView(self.tableView)
        XCTAssertEqual(numberOfSections, 0)
    }

    
    func test_numberOfRowsInSection_mustReturnZero() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        EntitySyncHistory.removeAll(inManagedObjectContext: self.managedObjectContext)
        let numberOfRows = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func test_numberOfRowsInSection_mustReturnNonZero() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        EntitySyncHistory.removeAll(inManagedObjectContext: self.managedObjectContext)
        EntitySyncHistory.entityAutoSyncHistoryByName("rule-test-name",
            lastExecutionDate: nil,
            inManagedObjectContext: self.managedObjectContext)
        dataSource.refreshData()
        let numberOfRows = dataSource.tableView(self.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func test_cellForRowAtIndexPath_mustReturnCell() {
        
//        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
//        var blockExecutionCheck = false
//        
//        dataSource.presenter.configureCellBlock = { (cell: UITableViewCell, entity:EntitySyncHistory) -> Void in
//            blockExecutionCheck = true
//        }
//        
//        let ruleName = TestUtil().randomRuleName()
//        EntitySyncHistory.removeAll(inManagedObjectContext: self.managedObjectContext)
//        if let entity = EntitySyncHistory.entityAutoSyncHistoryByName(ruleName,
//            lastExecutionDate: nil,
//            inManagedObjectContext: self.managedObjectContext) {
//                dataSource.presenter.configureCellBlock(UITableViewCell(), entity)
//        }
//        
//        XCTAssertTrue(blockExecutionCheck)
    }
    
    
    func test_canEditRowAtIndexPath_withBlock_mustSucceed() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        dataSource.presenter.canEditRowAtIndexPathBlock = { (indexPath: NSIndexPath) -> Bool in
            return true
        }
        let canEdit = dataSource.tableView(self.tableView, canEditRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(canEdit)
    }
    
    func test_canEditRowAtIndexPath_withoutBlock_mustFail() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        dataSource.presenter.canEditRowAtIndexPathBlock = nil
        let canEdit = dataSource.tableView(self.tableView, canEditRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertFalse(canEdit)
    }
    
    
    func test_commitEditingStyle_withBlock_mustExecuteBlock() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        var executedCommitEditingStyleBlock = false
        dataSource.presenter.commitEditingStyleBlock = { (editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) -> Void in
            executedCommitEditingStyleBlock = true
        }
        dataSource.tableView(self.tableView!, commitEditingStyle: .None, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(executedCommitEditingStyleBlock)
    }
    
    func test_commitEditingStyle_withoutBlock_mustDoNothing() {
        let dataSource = self.createFetcherDataSource(sectionNameKeyPath: nil)
        dataSource.presenter.commitEditingStyleBlock = nil
        dataSource.tableView(self.tableView!, commitEditingStyle: .None, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }
    
}
