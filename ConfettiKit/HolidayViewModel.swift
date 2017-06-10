import Foundation

public class HolidayViewModel: EventViewModel {
    public let holiday: Holiday
    
    public init(_ event: Event, holiday: Holiday) {
        self.holiday = holiday
        super.init(event)
    }
    
    public override var title: String {
        return "\(holiday.title) for \(event.person.firstName)"
    }
    
    public override var description: String {
        return "\(holiday.title) on \(shortMonthName) \(day)"
    }
}
