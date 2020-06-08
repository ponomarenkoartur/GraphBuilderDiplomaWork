//
//  AR_PlotUITests.swift
//  AR PlotUITests
//
//  Created by Artur on 05.06.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import XCTest

class AR_PlotUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTopicFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        let equationText = "sin(a*x)+sqrt(z)+b/c"
        let tablesQuery = app.tables
        let cells = tablesQuery.cells
        let sandboxCellText = cells.staticTexts["SANDBOX"]
        let showHideEquationsButton = app.buttons["doubleArrowUp"]
        let addEquationButton = cells.buttons["plusButton"]
        let equationEditingTextField = tablesQuery.cells.textFields["Enter equation here..."]
        let saveButton = tablesQuery.buttons["Save"]
        let backButton = app.buttons["backButton"]
        let savedEquationItem = tablesQuery.staticTexts["SAVED EQUATIONS"]
        let firstCell = cells.firstMatch
        let confirmButton = app.navigationBars["Saved Equations"].buttons["Confirm"]
        let tableView = app.tables.firstMatch
        
        sandboxCellText.tap()
        showHideEquationsButton.tap()
        addEquationButton.tap()
        equationEditingTextField.tap()
        equationEditingTextField.typeText(equationText)
        firstCell.swipeLeft()
        saveButton.tap()
        backButton.tap()
        savedEquationItem.tap()
        tableView.swipeUp()
        let lastCell = cells.allElementsBoundByIndex.last
        lastCell?.tap()
        confirmButton.tap()
        showHideEquationsButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier:"1").children(matching: .other).element(boundBy: 1).tap()
    }
}


extension XCTestCase {
    func wait(element: XCUIElement, duration: TimeInterval, handler: @escaping (Error?) -> Void = { _ in }) {
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: element) { () -> Bool in
            print("found it! 💪")
            handler(nil)
            return true
        }
        
        waitForExpectations(timeout: duration) { (error) in
            if let notFoundError = error {
                handler(notFoundError)
            }
        }
    }
}
