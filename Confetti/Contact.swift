import Foundation

import Contacts

public protocol Contact {
    var imageData: Data? { get }
    
    var name: String { get }
    var nick: String? { get }
}

public struct ManualContact: Contact {
    public var name: String
    public var nick: String?
    
    public let imageData: Data?
    
    public init(_ name: String, nick: String? = nil, imageData: Data? = nil) {
        self.name = name
        self.nick = nick
        self.imageData = imageData
    }
}
