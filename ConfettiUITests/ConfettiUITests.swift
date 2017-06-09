import XCTest
import VSMobileCenterExtensions

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
        
        MCLabel.labelStep("Login")
        
        app.buttons["I'd rather not"].tapIfExists()
        app.buttons["AddButton"].tap()
        
        MCLabel.labelStep("Add")
        
        app.buttons["Birthday"].tap()
        
        MCLabel.labelStep("Contacts")
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"John Appleseed").staticTexts["Detail"].tap()
        
        MCLabel.labelStep("Detail")
        
        app.buttons["Save"].tap()
        
        MCLabel.labelStep("Final")
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
