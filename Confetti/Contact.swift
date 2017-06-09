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
    
    public let imageData: Data? = nil
    
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}
