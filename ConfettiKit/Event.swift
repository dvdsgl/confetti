import Foundation

public class Event {
    public let person: Person
    public let occasion: Occasion
    
    public init(person: Person, occasion: Occasion) {
        self.person = person
        self.occasion = occasion
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
