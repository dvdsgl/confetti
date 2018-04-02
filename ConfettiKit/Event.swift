import Foundation

extension Event {
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
