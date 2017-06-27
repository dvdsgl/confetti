import Foundation

public protocol CreateEventSpec {
    func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event
    func initialDateFor(contact: Contact) -> DateComponents?
    
    var title: String { get }
    var description: String { get }
}

public struct CreateBirthdaySpec: CreateEventSpec {
    public init() {}
    
    public let title = "Whose Birthday?"
    public let description = "birthday"
    
    public func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .birthday(month: month, day: day, year: year)
        )
    }
    
    public func initialDateFor(contact: Contact) -> DateComponents? {
        return contact.birthday
    }
}

public struct CreateAnniversarySpec: CreateEventSpec {
    public init() {}
    
    public let title = "Whose Anniversary?"
    public let description = "anniversary"
    
    public func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .anniversary(month: month, day: day, year: year)
        )
    }
    
    public func initialDateFor(contact: Contact) -> DateComponents? {
        return nil
    }
}

public struct CreateMothersDaySpec: CreateEventSpec {
    public init() {}
    
    public let title = "Who's Mom?"
    public let description = "mother's day"
    
    public func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .holiday(holiday: .mothersDay)
        )
    }
    
    public func initialDateFor(contact: Contact) -> DateComponents? {
        return HolidayViewModel.nextOccurrence[.usa]?[.mothersDay]
    }
}

public struct CreateFathersDaySpec: CreateEventSpec {
    public init() {}
    
    public let title = "Who's Dad?"
    public let description = "father's day"
    
    public func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .holiday(holiday: .fathersDay)
        )
    }
    
    public func initialDateFor(contact: Contact) -> DateComponents? {
        return HolidayViewModel.nextOccurrence[.usa]?[.fathersDay]
    }
}
