import Foundation
let s = NSString()
public class Events {
    public static let samples = [
        Event(person: Person.david,
              occasion: .birthday(month: 3, day: 25, year: 1986)),
        Event(person: Person.ellen,
              occasion: .birthday(month: 2, day: 28, year: 1991)),
        Event(person: Person.stu,
              occasion: .birthday(month: 10, day: 27, year: 1979)),
        Event(person: Person.steve,
              occasion: .birthday(month: 12, day: 2, year: 1956)),
        Event(person: Person.hannah,
              occasion: .birthday(month: 2, day: 4, year: 1991)),
        Event(person: Person.vinicius,
              occasion: .birthday(month: 5, day: 6, year: 2000)),
        Event(person: Person.ian,
              occasion: .birthday(month: 5, day: 7, year: 1988)),
        Event(person: Person.carrie,
              occasion: .holiday(holiday: .mothersDay)),
        Event(person: Person.steve,
              occasion: .holiday(holiday: .fathersDay)),
        Event(person: Person("Judy"),
              occasion: .anniversary(month: 9, day: 20, year: 1960)),
    ].map { EventViewModel.fromEvent($0) }
}
