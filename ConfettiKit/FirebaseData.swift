import Foundation

public typealias FirebaseValue = [String: Any?]

public protocol FirebaseData {
    associatedtype Model
    
    var firebaseValue: FirebaseValue { get }
    static func fromFirebaseValue(_ value: FirebaseValue) -> Model?
}

extension FirebaseData {
    // When parsing an object as property of other FirebaseValue
    static func fromFirebaseValueAny(_ value: Any??) -> Model? {
        return fromFirebaseValue(value as! FirebaseValue)
    }
}
