import Foundation

public class Event {
    public var key: String? = nil
    public let person: Person
    public let occasion: Occasion
    
    public init(person: Person, occasion: Occasion) {
        self.person = person
        self.occasion = occasion
    }
    
    public func with(person: Person? = nil, occasion: Occasion? = nil) -> Event {
        let e = Event(
            person: person ?? self.person,
            occasion: occasion ?? self.occasion
        )
        e.key = key
        return e
    }
}

extension Event: FirebaseData {
    public var firebaseValue: FirebaseValue {
        return [
            "person": person.firebaseValue,
            "occasion": occasion.firebaseValue
        ]
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Event? {
        return Event(
            person: Person.fromFirebaseValueAny(value["person"])!,
            occasion: Occasion.fromFirebaseValueAny(value["occasion"])!
        )
    }
}
