import UIKit

class RepositoryListTableViewController: BaseTableViewController {

    // MARK: - BaseTableViewController override
    
    override func viewControllerTitle() -> String? {
        return NSLocalizedString("VC_REPOSITORY_LIST_TITLE", comment: "VC_REPOSITORY_LIST_TITLE")
    }
    
}
