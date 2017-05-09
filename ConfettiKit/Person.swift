import Foundation

public class Person {
    public let firstName: String
    public let photoUrl: String?
    
    public init(firstName: String, photoUrl: String? = nil) {
        self.firstName = firstName
        self.photoUrl = photoUrl
    }
    
    public convenience init(_ firstName: String, photoUrl: String? = nil) {
        self.init(firstName: firstName, photoUrl: photoUrl)
    }
    
    public static let ellen = Person(
        firstName: "Ellen",
        photoUrl: "https://confettiapp.com/v1/test/faces/ellen.jpg"
    )
    
    public static let david = Person(
        firstName: "David",
        photoUrl: "https://confettiapp.com/v1/test/faces/david.jpg"
    )
    
    public static let vinicius = Person(
        firstName: "Vinicius",
        photoUrl: "https://confettiapp.com/v1/test/faces/vinicius.jpg"
    )
    
    public static let stu = Person(
        firstName: "Stu",
        photoUrl: "https://confettiapp.com/v1/test/faces/stu.jpg"
    )
    
    public static let steve = Person(
        firstName: "Steve",
        photoUrl: "https://confettiapp.com/v1/test/faces/steve.jpg"
    )
    
    public static let carrie = Person(
        firstName: "Carrie"
    )
    
    public static let hannah = Person(
        firstName: "Hannah",
        photoUrl: "https://confettiapp.com/v1/test/faces/hannah.jpg"
    )
    
    public static let ian = Person(
        firstName: "Ian"
    )
    
    public static let antonio = Person(
        firstName: "Antonio"
    )
}
