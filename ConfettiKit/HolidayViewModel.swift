import Foundation

public class HolidayViewModel: EventViewModel {
    
    static let nextOccurrence: [Region: [Holiday: DateComponents]] = [
        .usa: [
            // Father's Day is the third Sunday of June
            .fathersDay: DateComponents(month: 6, weekday: 1, weekdayOrdinal: 3),
            // Father's Day is the second Sunday in May
            .mothersDay: DateComponents(month: 5, weekday: 1, weekdayOrdinal: 2)
        ]
    ]

    public let holiday: Holiday
    public let region = Region.usa
    
    public init(_ event: Event, holiday: Holiday) {
        self.holiday = holiday
        super.init(event)
    }
    
    public override var title: String {
        return "\(holiday.rawValue) for \(event.person.firstName)"
    }
    
    public override var description: String {
        return "\(holiday.rawValue) on \(shortMonthName) \(day)"
    }
    
    override var nextMatchingDateComponents: DateComponents? {
        return HolidayViewModel.nextOccurrence[region]?[holiday]
    }
}
