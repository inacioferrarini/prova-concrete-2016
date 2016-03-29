import UIKit
import CocoaLumberjack

class Logger: NSObject {

    override init() {
        DDLog.addLogger(DDASLLogger.sharedInstance())
        DDLog.addLogger(DDTTYLogger.sharedInstance())
        
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.maximumFileSize = 1024 * 1024
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger)
        super.init()
    }
    
    func logError(error:NSError) {
        DDLogError("\(error), \(error.userInfo)")
    }

    // TODO: Disable this method.
    func logErrorMessage(errorMessage:String) {
        DDLogError(errorMessage)
    }
    
    func logInfo(message:String) {
        DDLogInfo(message)
    }
    
}
