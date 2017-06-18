import Foundation

public class Person {
    public let name: String
    public let nickname: String?
    public let photoUUID: UUID?
    
    public init(name: String, nickname: String? = nil, photoUUID: UUID? = nil) {
        self.name = name
        self.nickname = nickname
        self.photoUUID = photoUUID
    }
    
    public func with(name: String? = nil, nickname: String? = nil, photoUUID: UUID? = nil) -> Person {
        let p = Person(
            name: name ?? self.name,
            nickname: nickname ?? self.nickname,
            photoUUID: photoUUID ?? self.photoUUID
        )
        return p
    }
    
    public var preferredName: String { return nickname ?? name }
}

extension Person: FirebaseData {
    public var firebaseValue: FirebaseValue {
        return [
            "name": name,
            "nickname": nickname,
            "photoUUID": photoUUID?.uuidString
        ]
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Person? {
        var photoUUID: UUID?
        
        if let uuidString = value["photoUUID"] as? String {
            photoUUID = UUID(uuidString: uuidString)
        }
        
        guard let name = (value["name"] ?? value["firstName"]) as? String else { return nil }
        
        return Person(
            name: name,
            nickname: value["nickname"] as? String,
            photoUUID: photoUUID
        )
    }
}
