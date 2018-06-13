import Foundation

public class AnniversaryViewModel: BirthdayViewModel {
    public override var title: String {
        if let nextAge = nextAge, nextAge > 0 {
            return "\(event.person.preferredName)'s \(nextAge)\(nextAge.th) Anniversary"
        } else {
            return "\(event.person.preferredName)'s Anniversary"
        }
    }
    
    public override var description: String {
        var base = "\(shortMonthName) \(day)"
        if let nextAge = nextAge {
            base = "\(nextAge)\(nextAge.th) anniversary on \(base)"
        } else {
            base = "Anniversary on \(base)"
        }
        return base
    }
    
    override var nextMatchingDateComponents: DateComponents? {
        guard case let .anniversary(month, day, _) = event.occasion.pattern else { return nil }
        return DateComponents(month: month, day: day)
    }
}
