import UIKit
@testable import GitHubSpy

class TestBaseDataBasedViewController: BaseDataBasedViewController {
    
    override func shouldSyncData() -> Bool {
        return true
    }
    
}
