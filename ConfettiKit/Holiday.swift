import Foundation

public enum Holiday {
    case mothersDay, fathersDay
}

public enum Region {
    case usa
}

extension Holiday {
    static func date(_ month: Int, _ day: Int, _ year: Int) -> DateComponents {
        return DateComponents(year: year, month: month, day: day)
    }
    
    static let upcomingInRegion: [Region: [Holiday: DateComponents]] = [
        .usa: [
            .mothersDay: date(5, 14, 2017),
            .fathersDay: date(6, 18, 2017)
        ]
    ]
    
    public func nextOccurrenceIn(region: Region) -> DateComponents {
        if let upcoming = Holiday.upcomingInRegion[region] {
            if let next = upcoming[self] {
                return next
            }
        }
        return DateComponents(year: 2019, month: 1, day: 1)
    }
    
    static let titles: [Holiday: String] = [
        .mothersDay: "Mother's Day",
        .fathersDay: "Father's Day",
    ]
    
    public var title: String {
        return Holiday.titles[self]!
    }
}
