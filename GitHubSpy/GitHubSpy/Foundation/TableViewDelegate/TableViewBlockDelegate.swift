import UIKit
import CoreData

class TableViewBlockDelegate: NSObject, UITableViewDelegate {

    let tableView:UITableView!
    let itemSelectionBlock:((indexPath: NSIndexPath) -> Void)!
    let loadMoreDataBlock:(() -> Void)?
    
    init(tableView:UITableView!, itemSelectionBlock:((indexPath: NSIndexPath) -> Void)!, loadMoreDataBlock:(() -> Void)?) {
        self.itemSelectionBlock = itemSelectionBlock
        self.tableView = tableView
        self.loadMoreDataBlock = loadMoreDataBlock
        super.init()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.itemSelectionBlock(indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        print("vou exibir a footer ... ")
    }
    
    func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        print("terminei de exibir a footer ... ")
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView.contentOffset.y < 0 {
            return
        } else if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height {
            if let loadMoreDataBlock = self.loadMoreDataBlock {
                loadMoreDataBlock()
            }
        }
    }
    
}
