import UIKit

extension UIViewController {
    
    func smallUserPhotoForUserUid(userLogin:String, url:String, placeHolderImage:UIImage, targetImageView:UIImageView) {
//        let key = userLogin
//        let store = ImageStore()
//        var photo = store.imageForKey(key)
//        
//        if nil == photo {
//            var photoLocation = url
//            photoLocation = photoLocation.stringByAppendingString("_75")
//            photo = store.imageFromUrl(photoLocation,
//                forKey: userLogin, withPlaceHolderImage: placeHolderImage, completionBlock: { (succeeded) -> Void in
//                    photo = store.imageForKey(key)
//                    if let photo = photo {
//                        targetImageView.image = UIImage.circularScaleAndCropImage(photo, frame: targetImageView.frame)
//                    }
//            })
//        }
//        
//        if let photo = photo {
//            targetImageView.image = UIImage.circularScaleAndCropImage(photo, frame: targetImageView.frame)
//        }
    }
    
}