import UIKit

class BaseDataBasedViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var courtain: UIView?
    
    
    // MARK: - Initialization
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performDataSyncIfNeeded()
    }
    
    
    // MARK: - Data Syncrhonization
    
    func performDataSyncIfNeeded() {
        if self.shouldSyncData() {
            self.showCourtainView()
            self.performDataSync()
        }
    }
    
    func dataSyncCompleted() {
        self.hideCourtainView()
    }
    
    func showCourtainView() {
        if let courtain = self.courtain {
            courtain.hidden = false
        }
        self.view.userInteractionEnabled = false
    }
    
    func hideCourtainView() {
        if let courtain = self.courtain {
            courtain.hidden = true
        }
        self.view.userInteractionEnabled = true
    }
    
    
    // MARK: - Child classes are expected to override these methods
    
    func shouldSyncData() -> Bool {
        return self.appContext.syncRules.shouldPerformSyncRule(self.dynamicType.simpleClassName(), atDate: NSDate())
    }
    
    func performDataSync() {
        self.dataSyncCompleted()
    }
    
}
