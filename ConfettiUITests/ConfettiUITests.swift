import XCTest
import VSMobileCenterExtensions

var screenshotsEnabledIfZero = 0

func suspendScreenshots() { screenshotsEnabledIfZero += 1 }
func resumeScreenshots() { screenshotsEnabledIfZero -= 1 }
var screenshotsEnabled: Bool { return screenshotsEnabledIfZero == 0 }

func withoutScreenshots(run: ()->()) {
    suspendScreenshots()
    run()
    resumeScreenshots()
}

func step(_ label: String, run: (()-> ())? = nil) {
    run?()
    
    if screenshotsEnabled {
        MCLabel.labelStep(label)
    }
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
    
    func addEvent(person: String) {
        let app = XCUIApplication()
        
        step("Add event") {
            app.buttons["AddButton"].tap()
        }
        
        step("Choose Birthday") {
            app.buttons["Birthday"].tap()
        }
        
        step("Choose '\(person)'") {
            let search = app.searchFields["Search Contacts"]
            search.tap()
            search.typeText(person)
            app.tables["contacts"].cells.element(boundBy: 0).tap()
        }
        
        step("Save") {
            app.buttons["Save"].tap()
        }
    }
    
    func testCreateABirthday() {
        let app = XCUIApplication()
        
        step("Login") {
            app.buttons["I'd rather not"].tapIfExists()
        }

        addEvent(person: "Ellen Appleseed")
        
        withoutScreenshots {
            for name in ["David", "Hannah", "Stu", "Carrie", "Vinicius"] {
                addEvent(person: "\(name) Appleseed")
            }
        }
        
        step("Main view")
        
        step("Event details") {
            app.cells.element(boundBy: 0).tap()
        }
        
        step("View profile") {
            app.buttons["Me"].tap()
        }
        
        app.staticTexts["Logout"].tap()
    }
}

extension XCUIElement {
    func tapIfExists() {
        if exists {
            tap()
        }
    }
}
