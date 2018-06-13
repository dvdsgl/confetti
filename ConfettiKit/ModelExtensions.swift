import Foundation

extension Array {
    // TODO name this better
    func options<T>(_ filter: (Element) -> T?) -> [T] {
        var result = [T]()
        for x in self {
            guard let fx = filter(x) else { continue }
            result.append(fx)
        }
        return result
    }
}

extension Person {
    public func with(firstName: String? = nil, lastName: String? = nil, nickname: String? = nil, emails: [String]? = nil, phones: [Phone]? = nil, photoUUID: String? = nil) -> Person {
        let p = Person(
            emails: emails ?? self.emails,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            nickname: nickname ?? self.nickname,
            phones: phones ?? self.phones,
            photoUUID: photoUUID ?? self.photoUUID
        )
        return p
    }
    
    public var fullName: String {
        return "\(firstName) \(lastName ?? "")".trimmingCharacters(in: .whitespaces)
    }
    
    public var preferredName: String { return nickname ?? fullName }
}

public enum OccasionPattern {
    case birthday(month: Int, day: Int, year: Int?)
    // May want to add Region here
    case holiday(holiday: OccasionKind)
    case anniversary(month: Int, day: Int, year: Int?)
}

extension OccasionPattern {
    public var occasion: Occasion {
        switch self {
        case let .anniversary(month: month, day: day, year: year):
            return Occasion(day: day, kind: .anniversary, month: month, year: year)
        case let .birthday(month: month, day: day, year: year):
            return Occasion(day: day, kind: .birthday, month: month, year: year)
        case let .holiday(holiday:  kind):
            return Occasion(day: 0, kind: kind, month: 0, year: nil)
        }
    }
}

extension Occasion {
    public var pattern: OccasionPattern {
        switch kind {
        case .anniversary:
            return .anniversary(month: month, day: day, year: year)
        case .birthday:
            return .birthday(month: month, day: day, year: year)
        default:
            return .holiday(holiday: kind)
        }
    }
}

public extension Event {
    public convenience init(person: Person, occasion occasionEnum: OccasionPattern) {
        self.init(key: nil, occasion: occasionEnum.occasion, person: person)
    }
    
    public func with(key: String? = nil, occasion: Occasion? = nil, person: Person? = nil) -> Event {
        return Event(key: key ?? self.key, occasion: occasion ?? self.occasion, person: person ?? self.person)
    }
}
