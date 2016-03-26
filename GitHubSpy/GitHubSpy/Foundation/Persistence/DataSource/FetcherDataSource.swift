import UIKit
import CoreData

class FetcherDataSource<EntityType: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    private(set) weak var tableView:UITableView!
    private(set) var entityName: String!
    var predicate: NSPredicate? {
        didSet {
            self.fetchedResultsController.fetchRequest.predicate = predicate
            self.refreshData()
        }
    }
    var fetchLimit: NSInteger?
    var sortDescriptors: [NSSortDescriptor]!
    var sectionNamesKeyPath: String?
    var cacheName: String?
    private(set) weak var managedObjectContext:NSManagedObjectContext!
    private(set) var presenter:TableViewCellPresenter<EntityType, UITableViewCell>!
    
    // MARK: - Initialization
    
    init(targetingTableView tableView:UITableView!,
         presenter:TableViewCellPresenter<EntityType, UITableViewCell>!,
         entityName: String!,
         sortDescriptors: [NSSortDescriptor]!,
         managedObjectContext context:NSManagedObjectContext!) {
    
        self.tableView = tableView
        self.presenter = presenter
        self.entityName = entityName
        self.managedObjectContext = context
        super.init()
    }
    
    convenience init(targetingTableView tableView:UITableView!,
         presenter:TableViewCellPresenter<EntityType, UITableViewCell>!,
         entityName: String!,
         sortDescriptors: [NSSortDescriptor]!,
         managedObjectContext context:NSManagedObjectContext!,
         predicate: NSPredicate?,
         fetchLimit: NSInteger?,
         sectionNamesKeyPath: String?,
         cacheName: String?) {
            
            self.init(targetingTableView: tableView, presenter:presenter, entityName: entityName, sortDescriptors: sortDescriptors, managedObjectContext: context)
        
        self.predicate = predicate
        self.fetchLimit = fetchLimit
        self.sectionNamesKeyPath = sectionNamesKeyPath
        self.cacheName = cacheName
    }
    
    
    // MARK: - Public Methods
    
    func refreshData() {
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            
        }

        self.tableView.reloadData()
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
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
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
        let entity = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        fetchRequest.predicate = self.predicate
        
        if let fetchLimit = self.fetchLimit where fetchLimit > 0 {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        fetchRequest.fetchBatchSize = 100
        fetchRequest.sortDescriptors = self.sortDescriptors

        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: self.sectionNamesKeyPath, cacheName: self.cacheName)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
//            print("Unresolved error \(error), \(error.userInfo)")
        }
        
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
            let cell = tableView.cellForRowAtIndexPath(indexPath!)!
            self.presenter.configureCellBlock(cell, value)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}
