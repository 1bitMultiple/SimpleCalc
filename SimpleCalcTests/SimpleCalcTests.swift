//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by kamezawa.takayuki on 2022/01/14.
//

import XCTest
@testable import SimpleCalc
import SwiftUI

class SimpleCalcTests: XCTestCase {
    let model = CalclationModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let result = model.displayNumber
        XCTAssertEqual(result, "0")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPushNumberButton() throws {
        let testButtons = ["1","2","3","3","4","5","6","7","8","9","0"]
        var testResult = ""
        for number in testButtons {
            pressButton(button: number)
            testResult += number
            let result = model.displayNumber
            XCTAssertEqual(result, testResult)
        }
        model.allClear()
        let displayResult = model.displayNumber
        XCTAssertEqual(displayResult, "0")
        let computation = model.computation
        XCTAssertEqual(computation, NSDecimalNumber.zero)
    }

    func testZeroStartPushNumberButton() throws {
        let testButtons = ["0","0","1","2","3","3","4","5","6","7","8","9","0"]
        var testResult = ""
        for number in testButtons {
            pressButton(button: number)
            testResult = NSDecimalNumber(string: testResult + number).stringValue
            let result = model.displayNumber
            print("debug: \(result) : \(testResult)")
            XCTAssertEqual(result, testResult)
        }
        model.allClear()
        let displayResult = model.displayNumber
        XCTAssertEqual(displayResult, "0")
        let computation = model.computation
        XCTAssertEqual(computation, NSDecimalNumber.zero)
    }

    func testZeroStartDecimalPushNumberButton() throws {
        let testButtons = ["0",".","1","2","3","3","4","5","6","7","8","9","0"]
        var testResult = ""
        for number in testButtons {
            pressButton(button: number)
            testResult = testResult + number
            let result = model.displayNumber
            print("debug: \(result) : \(testResult)")
            XCTAssertEqual(result, testResult)
        }
        model.allClear()
        let displayResult = model.displayNumber
        XCTAssertEqual(displayResult, "0")
        let computation = model.computation
        XCTAssertEqual(computation, NSDecimalNumber.zero)
    }


    func testPointPushNumberButton() throws {
        let testButtons = ["1",".","2","3","3","4","5","6","7","8","9","0"]
        var testResult = ""
        for number in testButtons {
            pressButton(button: number)
            let result = model.displayNumber
            testResult += number
            print("debug: \(result) : \(testResult)")
            XCTAssertEqual(result, testResult)
        }
        model.allClear()
    }

    func testMultiPointPushNumberButton() throws {
        let testButtons = ["1",".","2",".","3",".","4",".","5",".","6"]
        for number in testButtons {
            pressButton(button: number)
        }
        let result = model.displayNumber
        XCTAssertEqual(result, "1.23456")
        model.allClear()
    }

    func testSignPushNumberButton() throws {
        let testButtons = ["±","1","±","2","±","3"]
        let testResult = ["-0","-1","1","12","-12","-123"]
        for (index,number) in testButtons.enumerated() {
            pressButton(button: number)
            let result = model.displayNumber
            print("debug: \(result) = \(testResult[index])")
            XCTAssertEqual(result, testResult[index])
        }
        model.allClear()
    }

    func pressButton(button: String) {
        if button == "±" {
            model.toggleNegative()
        } else if button == "." {
            model.addPoint()
        } else if button == "c" {
            model.clear()
        } else if button == "a" {
            model.allClear()
        } else if button == "+" {
            model.calcurate(.addition)
        } else if button == "-" {
            model.calcurate(.subtraction)
        } else if button == "*" {
            model.calcurate(.multiplication)
        } else if button == "/" {
            model.calcurate(.divide)
        } else if button == "=" {
            model.calcurate(.equals)
        } else {
            model.appendNumber(button)
        }
    }

}
