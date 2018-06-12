import SQLite

import Foundation
import UIKit

import ConfettiKit

struct AkavacheOrAzureEvent {
    let person: AkavacheOrAzurePerson
    let date: Date
    let occasionKind: String
    let hasYear: Bool
    
    func toEvent() -> Event {
        return Event(person: person.toPerson(), occasion: occasion)
    }
    
    var occasion: Occasion {
        get {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            switch occasionKind {
            case "Birthday":
                return .birthday(month: month, day: day, year: hasYear ? year : nil)
            case "Anniversary":
                return .anniversary(month: month, day: day, year: hasYear ? year : nil)
            case "MothersDay":
                return .holiday(holiday: .mothersDay)
            case "FathersDay":
                return .holiday(holiday: .fathersDay)
            default:
                fatalError("Unexpected occasion value")
            }
        }
    }
}

struct AkavacheOrAzurePerson: Codable {
    let id, firstName, lastName: String
    let nickName, photoKey: String?
    let emails: [String]
    let phoneNumbers: [PhoneNumber]
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case firstName = "FirstName"
        case lastName = "LastName"
        case nickName = "NickName"
        case photoKey = "PhotoKey"
        case emails = "Emails"
        case phoneNumbers = "PhoneNumbers"
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(AkavacheOrAzurePerson.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
    func toPerson() -> Person {
        return Person(
            name: "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines),
            nickname: nickName,
            emails: emails.map{ Labeled($0) },
            phones: phoneNumbers.map{ Labeled($0.number, label: $0.kind.description) },
            photoUUID: nil
        )
    }
}

struct PhoneNumber: Codable {
    let number: String
    let kind: Int
    
    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case kind = "Kind"
    }
}

class Azure {
    static func getEasyTableEvents() throws -> [AkavacheOrAzureEvent] {
        var events = [AkavacheOrAzureEvent]()
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let azuredb = documents.appendingPathComponent("confetti.db")
        let db = try Connection(azuredb.absoluteString)
        
        for event in try db.prepare(Table("EventModel")) {
            let occasion = event[Expression<String>("occasion")]
            let date = Date(timeIntervalSince1970: Double(event[Expression<Int64>("date")]))
            let person = try! AkavacheOrAzurePerson(event[Expression<String>("person")])
            let hasYear = event[Expression<Bool>("specifiesYear")]
            events.append(AkavacheOrAzureEvent(person: person, date: date, occasionKind: occasion, hasYear: hasYear))
        }
        
        return events
    }
}
