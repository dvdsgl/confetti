import Foundation

public class Event {
    public let person: Person
    public let occasion: Occasion
    
    public init(person: Person, occasion: Occasion) {
        self.person = person
        self.occasion = occasion
    }
}
