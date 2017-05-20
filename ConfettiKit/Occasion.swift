import Foundation

public enum Occasion {
    case birthday(month: Int, day: Int, year: Int?)
    
    // May want to add Region here
    case holiday(holiday: Holiday)
    
    case anniversary(month: Int, day: Int, year: Int?)
}

extension Occasion: FirebaseData {
    public var firebaseValue: FirebaseValue {
        switch self {
        case let .birthday(month, day, year):
            return [
                "case": "birthday",
                "day": day,
                "month": month,
                "year": year
            ]
        case let .holiday(holiday):
            return [
                "case": "holiday",
                "holiday": holiday.firebaseValue
            ]
        case let .anniversary(month, day, year):
            return [
                "case": "anniversary",
                "day": day,
                "month": month,
                "year": year
            ]
        }
    }
    
    public static func fromFirebaseValue(_ value: FirebaseValue) -> Occasion? {
        switch value["case"] as! String {
        case "birthday":
            return .birthday(
                month: value["month"] as! Int,
                day: value["day"] as! Int,
                year: value["year"] as? Int
            )
        case "holiday":
            return .holiday(
                holiday: Holiday.fromFirebaseValueAny(value["holiday"])!
            )
        case "anniversary":
            return .anniversary(
                month: value["month"] as! Int,
                day: value["day"] as! Int,
                year: value["year"] as? Int
            )
        default:
            return nil
        }
    }
}
