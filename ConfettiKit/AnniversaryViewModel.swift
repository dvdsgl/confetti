import Foundation

public class AnniversaryViewModel: BirthdayViewModel {
    public override var description: String {
        var base = "\(shortMonthName) \(day)"
        if let nextAge = nextAge {
            base = "\(nextAge)\(nextAge.th) anniversary on \(base)"
        } else {
            base = "Anniversary on \(base)"
        }
        return base
    }
}
