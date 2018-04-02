// To parse the JSON, add this file to your project and do:
//
//   let event = try? JSONDecoder().decode(Event.self, from: jsonData)
//   let person = try? JSONDecoder().decode(Person.self, from: jsonData)
//   let labeledString = try? JSONDecoder().decode(LabeledString.self, from: jsonData)
//   let occasion = try? JSONDecoder().decode(Occasion.self, from: jsonData)
//   let occasionKind = try? JSONDecoder().decode(OccasionKind.self, from: jsonData)

import Foundation

struct Event: Codable {
    let key: String?
    let name: String
    let person: Person
    let occasion: Occasion
}

struct Occasion: Codable {
    let kind: OccasionKind
    let month, day: Double
    let year: Double?
}

enum OccasionKind: String, Codable {
    case anniversary = "Anniversary"
    case birthday = "Birthday"
    case fatherSDay = "Father's Day"
    case motherSDay = "Mother's Day"
}

struct Person: Codable {
    let name: String
    let nickname, photoUUID: String?
    let emails, phones: [LabeledString]
}

struct LabeledString: Codable {
    let value: String
    let label: String?
}
