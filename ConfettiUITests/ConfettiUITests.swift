import XCTest
import VSMobileCenterExtensions

func step(_ label: String, run: (()-> ())? = nil) {
    run?()
    MCLabel.labelStep(label)
}

class ConfettiUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["test"]
        app.launch()
    }
    
    override func tearDown() {
        // Called after the invocation of each test method
        super.tearDown()
    }
    
    func testCreateABirthday() {
        let app = XCUIApplication()
        
        step("Login") {
            app.buttons["I'd rather not"].tapIfExists()
        }
        
        step("Add event") {
            app.buttons["AddButton"].tap()
        }

        step("Choose Birthday") {
            app.buttons["Birthday"].tap()
        }

        step("Choose contact") {
            app.staticTexts["John Appleseed"].tap()
        }
        
        step("Save") {
            app.buttons["Save"].tap()
        }
        
        step("Main view")
        
        step("View profile") {
            app.buttons["Me"].tap()
        }
        
        app.staticTexts["Logout"].tap()
    }
}

extension XCUIElement {
    func tapIfExists() -> Bool {
        if exists {
            tap()
            return true
        } else {
            return false
        }
    }
}
