import UIKit

class ImageStore: NSObject {

    // MARK: - Private Properties
    
    private(set) var dictionary = [String : UIImage]()
    private(set) var inProgress = [String : Bool]()
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("clearCache"), name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }

    // MARK: - Lifecycle
    
    func clearCache() {
        self.dictionary.removeAll()
    }
    
    // MARK: - Public Methods

    func imageFromUrl(url:String, forKey key:String, withPlaceHolderImage placeHolder:UIImage, completionBlock:((succeeded:Bool) -> Void)?) -> UIImage {
        
        if true == self.inProgress[key] {
            return placeHolder
        }
        
        self.inProgress[key] = true
        self.setImage(placeHolder, forKey: key)
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) { () -> Void in
            if let imgUrl = NSURL(string: url) {
                let success = true
                if let data = NSData(contentsOfURL: imgUrl),
                    let image = UIImage(data: data) {
                
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.setImage(image, forKey: key)
                        self.inProgress.removeValueForKey(key)
                        
                        if let completionBlock = completionBlock {
                            completionBlock(succeeded: success)
                        }
                    })
                }
            }
        }
        
        return placeHolder
    }
    
    func imagePathForKey(key:String) -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        return documentDirectory.stringByAppendingPathComponent(key)
    }
    
    func setImage(image:UIImage, forKey key:String) {
        self.dictionary[key] = image
        
        let imagePath = self.imagePathForKey(key)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            data.writeToFile(imagePath, atomically: true)
        }
        
    }
    
    func imageForKey(key:String) -> UIImage? {
        
        let result = self.dictionary[key]
        
        if nil == result {
            let imagePath = self.imagePathForKey(key)
            if let result = UIImage(contentsOfFile: imagePath) {
                self.dictionary[key] = result
            }
        }
        
        return result
    }
    
    func deleteImageForKey(key:String) {
        self.dictionary.removeValueForKey(key)
        let imagePath = self.imagePathForKey(key)
        do {
            try NSFileManager.defaultManager().removeItemAtPath(imagePath)
        } catch {}
    }
    
}
