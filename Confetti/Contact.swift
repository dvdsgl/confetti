import UIKit
import Foundation

import Contacts

public enum ImageSource {
    case data(Data)
    case url(String)
}

public struct Labeled<T> {
    public let value: T
    public let label: String?
    
    public init(_ value: T, label: String? = nil) {
        self.value = value
        self.label = label
    }
}

public protocol Contact {
    var imageSource: ImageSource? { get }
    
    var firstName: String { get }
    var lastName: String? { get }
    
    var nick: String? { get }
    var birthday: DateComponents? { get }
    
    var emails: [String] { get }
    var phones: [Phone] { get }
}

extension Contact {
    public var fullName: String {
        return "\(firstName) \(lastName ?? "")".trimmingCharacters(in: .whitespaces)
    }
    
    public var preferredName: String { return nick ?? fullName }
}

public struct ManualContact: Contact {
    public var firstName: String
    public var lastName: String?
    
    public var nick: String?
    
    public var birthday: DateComponents?
    
    public var emails = [String]()
    public var phones = [Phone]()
    
    public let imageSource: ImageSource?
    
    public init(firstName: String, lastName: String? = nil, nick: String? = nil, imageSource: ImageSource? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.nick = nick
        self.imageSource = imageSource
    }
}

public extension Contact {
    var image: UIImage? {
        if let source = imageSource {
            switch source {
            case let .data(data):
                return UIImage(data: data)
            case let .url(url):
                guard let url = URL(string: url) else { return nil }
                guard let data = try? Data(contentsOf: url) else { return nil }
                return UIImage(data: data)
            }
        }
        return nil
    }
}
