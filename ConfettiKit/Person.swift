import Foundation

public class Person {
    public let firstName: String
    public let photoUrl: String?
    
    public init(firstName: String, photoUrl: String? = nil) {
        self.firstName = firstName
        self.photoUrl = photoUrl
    }
    
    public convenience init(_ firstName: String, photoUrl: String? = nil) {
        self.init(firstName: firstName, photoUrl: photoUrl)
    }
}

extension Person: FirebaseData {
    public var firebaseValue: FirebaseValue {
        return [
            "firstName": firstName,
            "photoUrl": photoUrl
        ]
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Person? {
        return Person(
            firstName: value["firstName"] as! String,
            photoUrl: value["photoUrl"] as? String
        )
    }
}
