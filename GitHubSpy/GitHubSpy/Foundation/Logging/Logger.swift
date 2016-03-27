import UIKit

class Logger: NSObject {

    func logError(error:NSError) {
        print("Unresolved error \(error), \(error.userInfo)")
    }

    func logErrorMessage(errorMessage:String) {
        print("Error: \(errorMessage)")
    }
    
    func logInfo(message:String) {
        print("Info: \(message)")
    }
    
}
