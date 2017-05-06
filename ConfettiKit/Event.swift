import Foundation

public class Event {
    
    public let year: Int?
    public let month: Int
    public let day: Int
    public let person: Person
    
    public init(person: Person, month: Int, day: Int, year: Int?) {
        self.person = person
        self.month = month
        self.day = day
        self.year = year
    }
}
