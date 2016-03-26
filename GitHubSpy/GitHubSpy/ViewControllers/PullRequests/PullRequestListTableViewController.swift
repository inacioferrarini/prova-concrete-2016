import UIKit

class PullRequestListTableViewController: BaseTableViewController {

    // MARK: - BaseTableViewController override
    
    override func viewControllerTitle() -> String? {
        return NSLocalizedString("VC_PULL_REQUEST_LIST_TITLE", comment: "VC_PULL_REQUEST_LIST_TITLE")
    }
    
}
