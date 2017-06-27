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
    
    func waitFor(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    override func tearDown() {
        // Called after the invocation of each test method
        super.tearDown()
    }
    
    func addEvent(person: String, waitForImages: Bool = false) {
        let app = XCUIApplication()
        
        step("Add event") {
            app.buttons["AddButton"].tap()
        }
        
        step("Choose Birthday") {
            app.buttons["Birthday"].tap()
        }
        
        if waitForImages {
            sleep(5)
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
        
        waitFor(element: app.buttons["Me"])
        step("Empty view")

        addEvent(person: "Ellen Appleseed", waitForImages: true)
        
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
