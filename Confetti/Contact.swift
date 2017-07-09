import UIKit
import Foundation

import Contacts

public enum ImageSource {
    case data(Data)
    case url(String)
}

public struct Labeled<T> {
    let value: T
    let label: String?
    
    public init(_ value: T, label: String? = nil) {
        self.value = value
        self.label = label
    }
}

public protocol Contact {
    var imageSource: ImageSource? { get }
    
    var name: String { get }
    var nick: String? { get }
    var birthday: DateComponents? { get }
    
    var emails: [Labeled<String>] { get }
    var phones: [Labeled<String>] { get }
}

public struct ManualContact: Contact {
    public var name: String
    public var nick: String?
    
    public var birthday: DateComponents?
    
    public var emails = [Labeled<String>]()
    public var phones = [Labeled<String>]()
    
    public let imageSource: ImageSource?
    
    public init(_ name: String, nick: String? = nil, imageSource: ImageSource? = nil) {
        self.name = name
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
