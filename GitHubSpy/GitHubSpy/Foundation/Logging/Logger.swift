import UIKit

class Logger: NSObject {

    func logError(error:NSError) {
        print("Unresolved error \(error), \(error.userInfo)")
    }
    
    func logInfo(message:String) {
        print("Info: \(message)")
    }
    
}
