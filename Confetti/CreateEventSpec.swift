import Foundation
import ConfettiKit

protocol CreateEventSpec {
    func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event
}

struct CreateBirthdaySpec: CreateEventSpec {
    func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .birthday(month: month, day: day, year: year)
        )
    }
    
}

struct CreateAnniversarySpec: CreateEventSpec {
    func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .anniversary(month: month, day: day, year: year)
        )
    }
    
}

struct CreateMothersDaySpec: CreateEventSpec {
    func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .holiday(holiday: .mothersDay)
        )
    }
    
}

struct CreateFathersDaySpec: CreateEventSpec {
    func createEvent(person: Person, month: Int, day: Int, year: Int?) -> Event {
        return Event(person: person,
                     occasion: .holiday(holiday: .fathersDay)
        )
    }
    
}
