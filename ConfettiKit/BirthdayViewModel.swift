
import Foundation

public class BirthdayViewModel: EventViewModel {
    public override var title: String {
        if let nextAge = nextAge, nextAge > 0 {
            return "\(event.person.firstName)'s \(nextAge)\(nextAge.th) Birthday"
        } else {
            return "\(event.person.firstName)'s Birthday"
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
        guard let year = year else { return nil }
        
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        let first = calendar.date(from: components)!
        
        return calendar.dateComponents([.year], from: first, to: nextOccurrence).year
    }
}
