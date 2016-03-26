import UIKit

class Logger: NSObject {

    func logError(message:String) {
        print("Error: \(message)")
    }
    
    func logInfo(message:String) {
        print("Info: \(message)")
    }
    
}
