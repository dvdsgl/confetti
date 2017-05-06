import Foundation

public class Events {
    public static let samples = [
        Event(person: Person.david, month: 3, day: 25, year: 1986),
        Event(person: Person.ellen, month: 2, day: 28, year: 1991),
        Event(person: Person.stu, month: 10, day: 27, year: 1979),
        Event(person: Person.steve, month: 12, day: 2, year: 1956),
        ].map { EventViewModel($0) }
}
