import Foundation

extension Array {
    // TODO name this better
    func options<T>(_ filter: (Element) -> T?) -> [T] {
        var result = [T]()
        for x in self {
            guard let fx = filter(x) else { continue }
            result.append(fx)
        }
        return result
    }
}

public class Person {
    public let name: String
    public let nickname: String?
    public let photoUUID: UUID?
    
    public let emails: [Labeled<String>]
    public let phones: [Labeled<String>]
    
    public init(name: String, nickname: String? = nil, emails: [Labeled<String>]? = nil, phones: [Labeled<String>]? = nil, photoUUID: UUID? = nil) {
        self.name = name
        self.nickname = nickname
        self.emails = emails ?? []
        self.phones = phones ?? []
        self.photoUUID = photoUUID
    }
    
    public func with(name: String? = nil, nickname: String? = nil, emails: [Labeled<String>]? = nil, phones: [Labeled<String>]? = nil, photoUUID: UUID? = nil) -> Person {
        let p = Person(
            name: name ?? self.name,
            nickname: nickname ?? self.nickname,
            emails: emails ?? self.emails,
            phones: phones ?? self.phones,
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
            "emails": labeledStringsToFirebaseValues(emails),
            "phones": labeledStringsToFirebaseValues(phones),
            "photoUUID": photoUUID?.uuidString
        ]
    }
    
    private func labeledStringsToFirebaseValues(_ xs: [Labeled<String>]) -> [FirebaseValue] {
        return xs.map { ["value": $0.value, "label": $0.label] }
    }
    
    private static func labeledStringsFromFirebaseValues(_ xs: [FirebaseValue]) -> [Labeled<String>] {
        return xs.options { val in
            guard let value = val["value"] as? String else { return nil }
            let label = val["label"] as? String
            return Labeled<String>(value, label: label)
        }
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Person? {
        var photoUUID: UUID?
        
        if let uuidString = value["photoUUID"] as? String {
            photoUUID = UUID(uuidString: uuidString)
        }
        
        guard let name = (value["name"] ?? value["firstName"]) as? String else { return nil }
        
        let emailValues = value["emails"] as? [FirebaseValue] ?? []
        let phoneValues = value["phones"] as? [FirebaseValue] ?? []
        
        return Person(
            name: name,
            nickname: value["nickname"] as? String,
            emails: labeledStringsFromFirebaseValues(emailValues),
            phones: labeledStringsFromFirebaseValues(phoneValues),
            photoUUID: photoUUID
        )
    }
}
