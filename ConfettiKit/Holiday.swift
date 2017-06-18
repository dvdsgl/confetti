import Foundation

public enum Region {
    case usa
}

public enum Holiday: String {
    case mothersDay = "Mother's Day"
    case fathersDay = "Father's Day"
}

extension Holiday: FirebaseData {
    public var firebaseValue: FirebaseValue {
        return ["case": rawValue]
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Holiday? {
        let raw = (value["case"] as? String) ?? ""
        return Holiday(rawValue: raw)
    }
}
