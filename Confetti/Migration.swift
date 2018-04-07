import SQLite

import Foundation
import UIKit

struct OldEvent {
    let person: Person
    let date: Date
    let occasion: String
    let hasYear: Bool
}

struct Person: Codable {
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
        self = try JSONDecoder().decode(Person.self, from: data)
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
}

struct PhoneNumber: Codable {
    let number: String
    let kind: Int
    
    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case kind = "Kind"
    }
}

class Migration {
    static func getAzureEasyTableEvents() throws -> [OldEvent] {
        var events = [OldEvent]()
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let azuredb = documents.appendingPathComponent("confetti.db")
        let db = try Connection(azuredb.absoluteString)
        
        for event in try db.prepare(Table("EventModel")) {
            let occasion = event[Expression<String>("occasion")]
            let date = Date(timeIntervalSince1970: Double(event[Expression<Int64>("date")]))
            let person = try! Person(event[Expression<String>("person")])
            let hasYear = event[Expression<Bool>("specifiesYear")]
            events.append(OldEvent(person: person, date: date, occasion: occasion, hasYear: hasYear))
        }
        
        return events
    }
}
