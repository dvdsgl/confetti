import Foundation

public class HolidayViewModel: EventViewModel {
    
    static let nextOccurrence: [Region: [OccasionKind: DateComponents]] = [
        .usa: [
            // Father's Day is the third Sunday of June
            .fatherSDay: DateComponents(month: 6, weekday: 1, weekdayOrdinal: 3),
            // Father's Day is the second Sunday in May
            .motherSDay: DateComponents(month: 5, weekday: 1, weekdayOrdinal: 2)
        ]
    ]

    public let holiday: OccasionKind
    public let region = Region.usa
    
    public init(_ event: Event, holiday: OccasionKind) {
        self.holiday = holiday
        super.init(event)
    }
    
    public override var title: String {
        return "\(holiday.rawValue) for \(event.person.preferredName)"
    }
    
    public override var description: String {
        return "\(holiday.rawValue) on \(shortMonthName) \(day)"
    }
    
    override var nextMatchingDateComponents: DateComponents? {
        return HolidayViewModel.nextOccurrence[region]?[holiday]
    }
}
