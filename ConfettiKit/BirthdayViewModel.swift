
import Foundation

public class BirthdayViewModel: EventViewModel {
    public override var title: String {
        if let nextAge = nextAge, nextAge > 0 {
            return "\(event.person.preferredName)'s \(nextAge)\(nextAge.th) Birthday"
        } else {
            return "\(event.person.preferredName)'s Birthday"
        }
    }
    
    public override var description: String {
        var base = "\(shortMonthName) \(day)"
        if let nextAge = nextAge, nextAge > 0 {
            base = "Turns \(nextAge) on \(base)"
        } else {
            base = "Birthday on \(base)"
        }
        return base
    }
    
    var nextAge: Int? {
        guard case let .birthday(month, day, maybeYear) = event.occasion.pattern else { return nil }
        guard let year = maybeYear else { return nil }
        
        let components = DateComponents(year: year, month: month, day: day)
        let first = calendar.date(from: components)!
        
        return calendar.dateComponents([.year], from: first, to: nextOccurrence).year
    }
    
    override var nextMatchingDateComponents: DateComponents? {
        guard case let .birthday(month, day, _) = event.occasion.pattern else { return nil }
        
        return DateComponents(month: month, day: day)
    }
}
