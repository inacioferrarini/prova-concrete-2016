import UIKit
import CoreData

class TableViewCellPresenter<CellType: UITableViewCell, EntityType: NSManagedObject>: NSObject {
    
    let configureCellBlock:((CellType, EntityType) -> Void)!
    let cellReuseIdentifier:String!
    var canEditRowAtIndexPathBlock:((indexPath: NSIndexPath) -> Bool)?
    var commitEditingStyleBlock:((editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath: NSIndexPath) -> Void)?
       
    init(configureCellBlock:((CellType, EntityType) -> Void)!, cellReuseIdentifier:String!) {
        self.configureCellBlock = configureCellBlock
        self.cellReuseIdentifier = cellReuseIdentifier
        super.init()
    }
    
}
