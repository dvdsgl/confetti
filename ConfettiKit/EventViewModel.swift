import Foundation

public class EventViewModel {
    
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
    
    let event: Event
    
    public init(_ event: Event) {
        self.event = event
    }
    
    public var description: String {
        // Turning (nextAge) on
        var base = "\(monthName) \(event.day)\(th)"
        if let nextAge = nextAge {
            base = "Turning \(nextAge) on \(base)"
        } else {
            base = "Birthday on \(base)"
        }
        return base
    }
    
    public var person: Person {
        return event.person
    }
    
    var nextOccurrence: Date {
        return Calendar.current.nextDate(after: Date(),
                                         matching: DateComponents(month: event.month, day: event.day),
                                         matchingPolicy: .nextTime,
                                         repeatedTimePolicy: .first,
                                         direction: .forward)!
    }
    
    public var daysAway: Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: nextOccurrence).day!
    }
    
    public var weeksAway: Int {
        return daysAway / 7;
    }
    
    public var monthsAway: Int {
        return Calendar.current.dateComponents([.month], from: Date(), to: nextOccurrence).month!
    }
    
    var nextAge: Int? {
        guard let year = event.year else { return nil }
        
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: event.month, day: event.day)
        let first = calendar.date(from: components)!
        
        return calendar.dateComponents([.year], from: first, to: nextOccurrence).year
    }
    
    var monthName: String {
        let formatter = DateFormatter()
        return formatter.monthSymbols[event.month - 1]
    }
    
    var th: String {
        if event.day < 10 {
            return EventViewModel.suffixes[event.day]
        } else if event.day < 20 {
            return "th"
        } else {
            return EventViewModel.suffixes[event.day % 10]
        }
    }
}
