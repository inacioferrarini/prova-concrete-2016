import UIKit
import CoreData

class FetcherDataSource<EntityType: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    let tableView:UITableView
    private(set) var entityName: String
    var predicate: NSPredicate? {
        didSet {
            self.fetchedResultsController.fetchRequest.predicate = predicate
           // self.refreshData()
        }
    }
    var fetchLimit: NSInteger?
    var sortDescriptors: [NSSortDescriptor] {
        didSet {
            self.fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
           // self.refreshData()
        }
    }
    var sectionNameKeyPath: String?
    var cacheName: String?
    let managedObjectContext:NSManagedObjectContext
    private(set) var presenter:TableViewCellPresenter<UITableViewCell, EntityType>
    let logger:Logger
    
    // MARK: - Initialization
    
    init(targetingTableView tableView:UITableView,
         presenter:TableViewCellPresenter<UITableViewCell, EntityType>,
         entityName: String,
         sortDescriptors: [NSSortDescriptor],
         managedObjectContext context:NSManagedObjectContext,
         logger:Logger) {
    
        self.tableView = tableView
        self.presenter = presenter
        self.entityName = entityName
        self.sortDescriptors = sortDescriptors
        self.managedObjectContext = context
        self.logger = logger
        super.init()
    }
    
    convenience init(targetingTableView tableView:UITableView,
         presenter:TableViewCellPresenter<UITableViewCell, EntityType>,
         entityName: String,
         sortDescriptors: [NSSortDescriptor],
         managedObjectContext context:NSManagedObjectContext,
         logger:Logger,
         predicate: NSPredicate?,
         fetchLimit: NSInteger?,
         sectionNameKeyPath: String?,
         cacheName: String?) {
            
        self.init(targetingTableView: tableView, presenter:presenter, entityName: entityName, sortDescriptors: sortDescriptors, managedObjectContext: context, logger:logger)
        self.predicate = predicate
        self.fetchLimit = fetchLimit
        self.sectionNameKeyPath = sectionNameKeyPath
        self.cacheName = cacheName
    }
    
    
    // MARK: - Public Methods
    
    func refreshData() {
        do {
            try _fetchedResultsController!.performFetch()
            self.tableView.reloadData()
        } catch {
            let nserror = error as NSError
            self.logger.logError(nserror)
        }
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> EntityType {
        return self.fetchedResultsController.objectAtIndexPath(indexPath) as! EntityType
    }
    
    func indexPathForObject(object: EntityType) -> NSIndexPath? {
        return self.fetchedResultsController.indexPathForObject(object)
    }
    
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let value = self.objectAtIndexPath(indexPath)
        
        let reuseIdentifier = self.presenter.cellReuseIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        self.presenter.configureCellBlock(cell, value)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if let editRowBlock = self.presenter.canEditRowAtIndexPathBlock {
            return editRowBlock(indexPath: indexPath)
        }
        
        return false
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     
        if let commitEditingBlock = self.presenter.commitEditingStyleBlock {
            commitEditingBlock(editingStyle: editingStyle, forRowAtIndexPath: indexPath)
        }
        
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        fetchRequest.predicate = self.predicate
        
        if let fetchLimit = self.fetchLimit where fetchLimit > 0 {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        fetchRequest.fetchBatchSize = 100
        fetchRequest.sortDescriptors = self.sortDescriptors

        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: self.sectionNameKeyPath, cacheName: self.cacheName)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
//        do {
//            try _fetchedResultsController!.performFetch()
//        } catch {
//            let nserror = error as NSError
//            self.logger.logError(nserror)
//        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            let value = self.objectAtIndexPath(indexPath!)
            if let cell = tableView.cellForRowAtIndexPath(indexPath!) {
                self.presenter.configureCellBlock(cell, value)
            }
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}
