import Foundation

import Contacts

public protocol Contact {
    var firstName: String { get }
    var lastName: String { get }
    var imageData: Data? { get }
    
    var fullName: String { get }
}

public struct ManualContact: Contact {
    public var firstName, lastName: String
    
    public let imageData: Data?
    
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    public init(firstName: String, lastName: String, imageData: Data? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.imageData = imageData
    }
}
