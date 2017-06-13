// TODO move this into ConfettiKit when we figure out how to link Firebase there too

import Foundation
import UIKit

import ConfettiKit

import Firebase
import FirebaseStorageUI

import SDWebImage

extension EventViewModel {
    static fileprivate var imageCache = [UUID: UIImage]()
    
    func displayImage(in view: UIImageView) {
        if let cached = cachedImage {
            view.image = cached
        } else if let imageRef = imageReference {
            view.sd_setImage(with: imageRef)
        }
    }
    
    var cachedImage: UIImage? {
        guard let uuid = event.person.photoUUID else { return nil }
        return EventViewModel.imageCache[uuid]
    }
    
    var imageReference: StorageReference? {
        guard let uuid = event.person.photoUUID else { return nil }
        return imagesNode.child(uuid.uuidString)
    }
    
    fileprivate var imagesNode: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    func saveImage(_ image: UIImage) {
        let data = UIImageJPEGRepresentation(image, 0.5)!
        saveImage(data: data)
    }
    
    func saveImage(data: Data) {
        let uuid = UUID()
        let imageRef = imagesNode.child(uuid.uuidString)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let modifiedPerson = event.person.with(photoUUID: uuid)
        event = event.with(person: modifiedPerson)
        
        EventViewModel.imageCache[uuid] = UIImage(data: data)!
        UserViewModel.current.updateEvent(event)
        
        let _ = imageRef.putData(data, metadata: metadata) { (metadata, error) in
            if let _ = error {
                // ...
            } else {
                EventViewModel.imageCache.removeValue(forKey: uuid)
            }
        }
    }
}
