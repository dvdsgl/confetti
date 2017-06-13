import Foundation

public class Person {
    public let firstName: String
    public let photoUUID: UUID?
    
    public init(firstName: String, photoUUID: UUID? = nil) {
        self.firstName = firstName
        self.photoUUID = photoUUID
    }
    
    public convenience init(_ firstName: String) {
        self.init(firstName: firstName)
    }
    
    public func with(firstName: String? = nil, photoUUID: UUID? = nil) -> Person {
        let p = Person(
            firstName: firstName ?? self.firstName,
            photoUUID: photoUUID ?? self.photoUUID
        )
        return p
    }
}

extension Person: FirebaseData {
    public var firebaseValue: FirebaseValue {
        return [
            "firstName": firstName,
            "photoUUID": photoUUID?.uuidString
        ]
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Person? {
        var photoUUID: UUID?
        
        if let uuidString = value["photoUUID"] as? String {
            photoUUID = UUID(uuidString: uuidString)
        }
        
        return Person(
            firstName: value["firstName"] as! String,
            photoUUID: photoUUID
        )
    }
}
