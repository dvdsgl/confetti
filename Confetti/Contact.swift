import UIKit
import Foundation

import Contacts

public enum ImageSource {
    case data(Data)
    case url(String)
}

public protocol Contact {
    var imageSource: ImageSource? { get }
    
    var name: String { get }
    var nick: String? { get }
    var birthday: DateComponents? { get }
    
    var emails: [LabeledString] { get }
    var phones: [LabeledString] { get }
}

public struct ManualContact: Contact {
    public var name: String
    public var nick: String?
    
    public var birthday: DateComponents?
    
    public var emails = [LabeledString]()
    public var phones = [LabeledString]()
    
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
