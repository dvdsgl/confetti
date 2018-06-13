import Foundation

extension Contact {
    var person: Person {
        return Person(
            emails: emails,
            firstName: firstName,
            lastName: lastName,
            nickname: nick,
            phones: phones,
            photoUUID: nil
        )
    }
}

public protocol CreateEventSpec {
    func createEvent(contact: Contact, month: Int, day: Int, year: Int?) -> Event
    func initialDateFor(contact: Contact) -> DateComponents?
    
    var title: String { get }
    var description: String { get }
}

public struct CreateBirthdaySpec: CreateEventSpec {
    public init() {}
    
    public let title = "Whose Birthday?"
    public let description = "birthday"
    
    public func createEvent(contact: Contact, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: contact.person,
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
    
    public func createEvent(contact: Contact, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: contact.person,
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
    
    public func createEvent(contact: Contact, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: contact.person,
                     occasion: .holiday(holiday: .motherSDay)
        )
    }
    
    public func initialDateFor(contact: Contact) -> DateComponents? {
        return HolidayViewModel.nextOccurrence[.usa]?[.motherSDay]
    }
}

public struct CreateFathersDaySpec: CreateEventSpec {
    public init() {}
    
    public let title = "Who's Dad?"
    public let description = "father's day"
    
    public func createEvent(contact: Contact, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: contact.person,
                     occasion: .holiday(holiday: .fatherSDay)
        )
    }
    
    public func initialDateFor(contact: Contact) -> DateComponents? {
        return HolidayViewModel.nextOccurrence[.usa]?[.fatherSDay]
    }
}
