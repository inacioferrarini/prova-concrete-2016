import UIKit
import CoreData

class TableViewBlockDelegate: NSObject, UITableViewDelegate {

    let itemSelectionBlock:((indexPath: NSIndexPath) -> Void)!
    
    init(itemSelectionBlock:((indexPath: NSIndexPath) -> Void)!) {
        self.itemSelectionBlock = itemSelectionBlock
        super.init()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.itemSelectionBlock(indexPath: indexPath)
    }
    
}
