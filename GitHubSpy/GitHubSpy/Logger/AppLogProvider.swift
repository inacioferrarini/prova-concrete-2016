import UIKit
import York
import XCGLogger

public class AppLogProvider: NSObject, LogProvider {
    
    public let log = XCGLogger(identifier: "logger", includeDefaultDestinations: false)
    
    public override init() {
        super.init()
        
        self.setupDateFormat(log)
        log.logAppDetails()
        
        #if DEBUG
            let systemLogDestination = self.setupSystemLogger(log)
            log.addLogDestination(systemLogDestination)
            
            let fileLogDestination = self.setupFileLogger(log)
            log.addLogDestination(fileLogDestination)
        #else
            let fileLogDestination = self.setupFileLogger(log)
            log.addLogDestination(fileLogDestination)
        #endif
    }
    
    func setupDateFormat(log: XCGLogger) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        dateFormatter.locale = NSLocale.currentLocale()
        log.dateFormatter = dateFormatter
    }
    
    func setupSystemLogger(log: XCGLogger) -> XCGBaseLogDestination {
        let systemLogDestination = XCGNSLogDestination(owner: log, identifier: "advancedLogger.systemLogDestination")
        
        systemLogDestination.outputLogLevel = .Debug
        systemLogDestination.showLogIdentifier = false
        systemLogDestination.showFunctionName = true
        systemLogDestination.showThreadName = true
        systemLogDestination.showLogLevel = true
        systemLogDestination.showFileName = true
        systemLogDestination.showLineNumber = true
        systemLogDestination.showDate = true
        
        return systemLogDestination
    }
    
    func setupFileLogger(log: XCGLogger) -> XCGBaseLogDestination {
        let fileLogDestination = XCGFileLogDestination(owner: log, writeToFile: "GitHubSpy.log", identifier: "advancedLogger.fileLogDestination")
        
        fileLogDestination.outputLogLevel = .Debug
        fileLogDestination.showLogIdentifier = false
        fileLogDestination.showFunctionName = true
        fileLogDestination.showThreadName = true
        fileLogDestination.showLogLevel = true
        fileLogDestination.showFileName = true
        fileLogDestination.showLineNumber = true
        fileLogDestination.showDate = true
        
        fileLogDestination.logQueue = XCGLogger.logQueue
        
        return fileLogDestination
    }
    
    public func logError(error: NSError) {
        log.error("\(error), \(error.userInfo)")
    }
    
    public func logErrorMessage(errorMessage: String) {
        log.error(errorMessage)
    }
    
    public func logInfo(message: String) {
        log.info(message)
    }
    
}
