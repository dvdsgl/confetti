import Foundation

public protocol CreateEventSpec {
    func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event
    
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
}
