import Foundation

public protocol CreateEventSpec {
    func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event
}

public struct CreateBirthdaySpec: CreateEventSpec {
    public init() {}
    
    public func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .birthday(month: month, day: day, year: year)
        )
    }
    
}

public struct CreateAnniversarySpec: CreateEventSpec {
    public init() {}
    
    public func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .anniversary(month: month, day: day, year: year)
        )
    }
    
}

public struct CreateMothersDaySpec: CreateEventSpec {
    public init() {}
    
    public func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .holiday(holiday: .mothersDay)
        )
    }
    
}

public struct CreateFathersDaySpec: CreateEventSpec {
    public init() {}
    
    public func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .holiday(holiday: .fathersDay)
        )
    }
    
}
