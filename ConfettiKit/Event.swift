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
}

public class Event {
    public static let samples = [
        Event(person: Person.david, month: 3, day: 25, year: 1986),
        Event(person: Person.ellen, month: 2, day: 27, year: 1991)
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
    let person: Person
    
    public init(person: Person, month: Int, day: Int, year: Int?) {
        self.person = person
        self.year = year
        self.month = month
        self.day = day
    }
    
    public var description: String {
        var base = "\(person.firstName): \(monthName) \(day)\(th)"
        if let year = year {
            base = "\(base), \(year)"
        }
        return base
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
