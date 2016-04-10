import XCTest
@testable import GitHubSpy

class UIViewControllerImageExtensionTests: XCTestCase {

// Check how to display a ViewController during tests
//    let viewController = UIViewController()
//    let store = ImageStore()
//    
//    func test_smallUserPhotoForUserUid_image() {
//        let userLogin = "userLogin"
//        let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/2000px-User_icon_2.svg.png"
//        let placeHolderImage = UIImage(named: "default-avatar")
//        let imageView = UIImageView()
//        viewController.smallUserPhotoForUserUid(userLogin,
//            url: url,
//            placeHolderImage: placeHolderImage!,
//            targetImageView: imageView)
//    }
//    
//    func test_smallUserPhotoForUserUid_reuseImage() {
//        let userLogin = "userLogin"
//        let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/2000px-User_icon_2.svg.png"
//        let placeHolderImage = UIImage(named: "default-avatar")
//        let imageView = UIImageView()
//        viewController.smallUserPhotoForUserUid(userLogin,
//            url: url,
//            placeHolderImage: placeHolderImage!,
//            targetImageView: imageView)
//    }

    
    /*
    func smallUserPhotoForUserUid(userLogin:String, url:String, placeHolderImage:UIImage, targetImageView:UIImageView) {
        let key = userLogin
        let store = ImageStore()
        var photo = store.imageForKey(key)
        
        if nil == photo {
            var photoLocation = url
            photoLocation = photoLocation.stringByAppendingString("_75")
            photo = store.imageFromUrl(photoLocation,
                forKey: userLogin, withPlaceHolderImage: placeHolderImage, completionBlock: { (succeeded) -> Void in
                    photo = store.imageForKey(key)
                    if let photo = photo {
                        targetImageView.image = UIImage.circularScaleAndCropImage(photo, frame: targetImageView.frame)
                    }
            })
        }
        
        if let photo = photo {
            targetImageView.image = UIImage.circularScaleAndCropImage(photo, frame: targetImageView.frame)
        }
    }
*/
    
}
