import Foundation

public struct NotificationSpec {
    public let id, title, message: String
    public let daysBefore: Int
}

public class EventViewModel {
    
    static let soonDaysAway = 20
    
    public static func fromEvent(_ event: Event) -> EventViewModel {
        switch event.occasion {
        case .holiday(let holiday):
            return HolidayViewModel(event, holiday: holiday)
        case .birthday(_, _, _):
            return BirthdayViewModel(event)
        case .anniversary(_, _, _):
            return AnniversaryViewModel(event)
        }
    }
    
    public var event: Event
    
    init(_ event: Event) {
        self.event = event
    }
    
    public var isSoon: Bool {
        return daysAway <= EventViewModel.soonDaysAway
    }
    
    public var title: String {
        return "\(event.person.preferredName)'s Event"
    }
    
    public var description: String {
        return "\(daysAway) days away"
    }
    
    public var notifications: [NotificationSpec] {
        return [
            NotificationSpec(
                id: "10 days out",
                title: title,
                message: "\(title) is in 10 days. There's plenty of time to pick out a lovely gift.",
                daysBefore: 10
            ),
            NotificationSpec(
                id: "5 days out",
                title: title,
                message: "\(title) is in 5 days. There's just enough time to send something.",
                daysBefore: 5
            ),
            NotificationSpec(
                id: "day of",
                title: title,
                message: "Today is \(title). Get in touch!",
                daysBefore: 0
            )
        ]
    }
    
    public var person: Person {
        return event.person
    }
    
    var calendar: Calendar {
        return Calendar.current
    }
    
    var startOfToday: Date {
        return calendar.startOfDay(for: Date())
    }
    
    var startOfYesterday: Date {
        return calendar.date(byAdding: .day, value: -1, to: startOfToday)!
    }
    
    public var nextOccurrence: Date {
        return calendar.nextDate(after: startOfYesterday,
                                 matching: nextMatchingDateComponents!,
                                 matchingPolicy: .nextTime,
                                 repeatedTimePolicy: .first,
                                 direction: .forward)!
    }
    
    // This must be implemented by subclasses
    var nextMatchingDateComponents: DateComponents? {
        return nil
    }
    
    public var daysAway: Int {
        return calendar.dateComponents([.day], from: startOfToday, to: nextOccurrence).day!
    }
    
    public var weeksAway: Int {
        return Int(round(Float(daysAway) / 7.0))
    }
    
    public var monthsAway: Int {
        return calendar.dateComponents([.month], from: startOfToday, to: nextOccurrence).month!
    }
    
    public var countdown: String {
        switch (daysAway, weeksAway, monthsAway) {
        case (0, _, _):
            return "today"
        case (1, _, _):
            return "tomorrow"
        case (2...EventViewModel.soonDaysAway, _, _):
            return "\(daysAway) days"
        case (_, 1, _):
            return "1 week"
        case (_, 2..<4, _):
            return "\(weeksAway) weeks"
        case (_, _, 1):
            return "1 month"
        case (_, _, let months) where months < 12:
            return "\(months) months"
        default:
            return "a year"
        }
    }
    
    public var countdownMagnitudeAndUnit: (magnitude: Int, unit: String) {
        switch (daysAway, weeksAway, monthsAway) {
        case (0, _, _):
            return (0, "TODAY")
        case (1, _, _):
            return (1, "DAY")
        case (2...EventViewModel.soonDaysAway, _, _):
            return (daysAway, "DAYS")
        case (_, 1, _):
            return (1, "WEEK")
        case (_, 2..<4, _):
            return (weeksAway, "WEEKS")
        case (_, _, 1):
            return (1, "MONTH")
        case (_, _, let months) where months < 12:
            return (months, "MONTHS")
        default:
            return (1, "YEAR")
        }
    }
    
    var monthName: String {
        let formatter = DateFormatter()
        return formatter.monthSymbols[month - 1]
    }
    
   public var shortMonthName: String {
        let formatter = DateFormatter()
        return formatter.shortMonthSymbols[month - 1]
    }
    
    public var month: Int {
        return calendar.component(.month, from: nextOccurrence)
    }
    
    public var day: Int {
        return calendar.component(.day, from: nextOccurrence)
    }
    
    public var year: Int {
        return calendar.component(.year, from: nextOccurrence)
    }
}

extension Int {
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
    
    public var th: String {
        if self < 10 {
            return Int.suffixes[self]
        } else if self < 20 {
            return "th"
        } else {
            return Int.suffixes[self % 10]
        }
    }
}
