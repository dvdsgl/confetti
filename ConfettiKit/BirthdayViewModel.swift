
import Foundation

public class BirthdayViewModel: EventViewModel {
    public override var description: String {
        var base = "\(shortMonthName) \(day)"
        if let nextAge = nextAge {
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
