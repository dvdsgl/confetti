import Foundation

public enum Occasion {
    case birthday(month: Int, day: Int, year: Int?)
    
    // May want to add Region here
    case holiday(holiday: Holiday)
    
    case anniversary(month: Int, day: Int, year: Int?)
}
