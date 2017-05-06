import Foundation

public class Person {
    public let firstName: String
    
    public init(firstName: String) {
        self.firstName = firstName
    }
    
    public static let ellen = Person(
        firstName: "Ellen"
    )
    
    public static let david = Person(
        firstName: "David"
    )
    
    public static let stu = Person(
        firstName: "Stu"
    )
    
    public static let steve = Person(
        firstName: "Steve"
    )
}

public class Event {
    public static let samples = [
        Event(person: Person.david, month: 3, day: 25, year: 1986),
        Event(person: Person.ellen, month: 2, day: 28, year: 1991),
        Event(person: Person.stu, month: 10, day: 27, year: 1979),
        Event(person: Person.steve, month: 12, day: 2, year: 1956),
    ]
    
    static let suffixes = [
        /*0*/"th",
        /*1*/"st",
        /*2*/"nd",
        /*3*/"rd",
        /*4*/"th",
        /*5*/"th",
        /*6*/"th",
        /*7*/"th",
        /*8*/"th",
        /*9*/"th",
        /*10*/"th"
    ]
    
    var year: Int?
    var month: Int
    var day: Int
    public let person: Person
    
    public init(person: Person, month: Int, day: Int, year: Int?) {
        self.person = person
        self.year = year
        self.month = month
        self.day = day
    }
    
    public var description: String {
        // Turning (nextAge) on 
        var base = "\(monthName) \(day)\(th)"
        if let nextAge = nextAge {
            base = "Turning \(nextAge) on \(base)"
        } else {
            base = "Birthday on \(base)"
        }
        return base
    }
    
    var nextOccurrence: Date {
        return Calendar.current.nextDate(after: Date(),
                                  matching: DateComponents(month: month, day: day),
                                  matchingPolicy: .nextTime,
                                  repeatedTimePolicy: .first,
                                  direction: .forward)!
    }
    
    public var daysAway: Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: nextOccurrence).day!
    }
    
    var nextAge: Int? {
        guard let year = year else { return nil }

        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        let first = calendar.date(from: components)!
        
        return calendar.dateComponents([.year], from: first, to: nextOccurrence).year
    }
    
    var monthName: String {
        let formatter = DateFormatter()
        return formatter.monthSymbols[month - 1]
    }
    
    var th: String {
        if day < 10 {
            return Event.suffixes[day]
        } else if day < 20 {
            return "th"
        } else {
            return Event.suffixes[day % 10]
        }
    }
}
