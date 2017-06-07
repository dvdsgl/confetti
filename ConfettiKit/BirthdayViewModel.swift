
import Foundation

public class BirthdayViewModel: EventViewModel {
    public override var title: String {
        return "\(event.person.firstName)'s Birthday"
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
    
    public override var notifications: [NotificationSpec] {
        return [
            NotificationSpec(
                id: "day of",
                title: "Today is \(title)!",
                message: description,
                daysBefore: 0
            ),
            NotificationSpec(
                id: "coming up",
                title: "\(title) is coming up",
                message: description,
                daysBefore: EventViewModel.soonDaysAway
            )
        ]
    }
    
    var nextAge: Int? {
        guard let year = year else { return nil }
        
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        let first = calendar.date(from: components)!
        
        return calendar.dateComponents([.year], from: first, to: nextOccurrence).year
    }
}
