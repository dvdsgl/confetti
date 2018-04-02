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
    public init(name: String, nickname: String? = nil, emails: [LabeledString]? = nil, phones: [LabeledString]? = nil, photoUUID: String? = nil) {
        self.name = name
        self.nickname = nickname
        self.emails = emails ?? []
        self.phones = phones ?? []
        self.photoUUID = photoUUID
    }
    
    public func with(name: String? = nil, nickname: String? = nil, emails: [LabeledString]? = nil, phones: [LabeledString]? = nil, photoUUID: String? = nil) -> Person {
        let p = Person(
            name: name ?? self.name,
            nickname: nickname ?? self.nickname,
            emails: emails ?? self.emails,
            phones: phones ?? self.phones,
            photoUUID: photoUUID ?? self.photoUUID
        )
        return p
    }
    
    public var preferredName: String { return nickname ?? name }
}
