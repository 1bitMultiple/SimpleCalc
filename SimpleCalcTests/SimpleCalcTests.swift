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

    func testPushMultiNumber() throws {
        let testButtons = ["12345","12345.6789","-12345","-12345.6789"]
        let testResult = ["12345","12345.6789","-12345","-12345.6789"]
        for (index,number) in testButtons.enumerated() {
            pressButton(button: number)
            let result = model.displayNumber
            XCTAssertEqual(result, testResult[index])
            model.allClear()
        }
    }

    func testZeroStartPushNumberButton() throws {
        let testButtons = ["0","0","1","2","3","3","4","5","6","7","8","9","0"]
        var testResult = ""
        for number in testButtons {
            pressButton(button: number)
            testResult = NSDecimalNumber(string: testResult + number).stringValue
            let result = model.displayNumber
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
            XCTAssertEqual(result, testResult[index])
        }
        model.allClear()
    }

    func testAddition() throws {
        let testButtons = [["1","+","2","="], ["-1","+","2","="], ["-5","+","2","="], ["-3","+","-2","="],
                           ["1","+",".3","="],["1.2","+","2.8","="],
                           ["1.5","+","3","±","="], ["1.2","±","+","9","="]]
        let testResult = ["3","1","-3","-5",
                          "1.3","4"
                          ,"-1.5", "7.8"]
        for (index, buttons) in testButtons.enumerated() {
            var calc = ""
            for operate in buttons {
                calc += operate
                pressButton(button: operate)
            }
            let result = model.displayNumber
            XCTAssertEqual(result, testResult[index])
            model.allClear()
        }
        model.allClear()
    }

    func testSubtraction() throws {
        let testButtons = [["4","-","2","="], ["2","-","2","="], ["-5","-","2","="], ["-3","-","-2","="],
                           ["1","-",".3","="],["1.2","-","2.8","="],
                           ["1.5","-","3","±","="], ["1.2","±","-","9","="]]
        let testResult = ["2","0","-7","-1",
                          "0.7","-1.6",
                          "4.5", "-10.2"]
        for (index, buttons) in testButtons.enumerated() {
            var calc = ""
            for operate in buttons {
                calc += operate
                pressButton(button: operate)
            }
            let result = model.displayNumber
            XCTAssertEqual(result, testResult[index])
            model.allClear()
        }
        model.allClear()
    }

    func testMultiplication() throws {
        let testButtons = [["4","*","2","="], ["2","*","-3","="], ["-5","*","2","="], ["-3","*","-2","="],
                           ["1","*",".3","="],["1.2","*","2.8","="],
                           ["1.5","*","3","±","="], ["1.2","±","*","9","="]]
        let testResult = ["8","-6","-10","6",
                          "0.3","3.36",
                          "-4.5", "-10.8"]
        for (index, buttons) in testButtons.enumerated() {
            var calc = ""
            for operate in buttons {
                calc += operate
                pressButton(button: operate)
            }
            let result = model.displayNumber
            XCTAssertEqual(result, testResult[index])
            model.allClear()
        }
        model.allClear()
    }

    func testDivideRationalNumber() {
        let testButtons = [["4","/","2","="], ["9","/","-3","="], ["-6","/","3","="], ["-12","/","-4","="],
                           ["1","/",".2","="],["1.2","/","2.4","="],
                           ["1.5","/","3","±","="], ["1.2","±","/","3","="],
                           ["1.5","/","0","="]]
        let testResult = ["2","-3","-2","3",
                          "5","0.5",
                          "-0.5", "-0.4",
                          "error"]
        for (index, buttons) in testButtons.enumerated() {
            var calc = ""
            for operate in buttons {
                calc += operate
                pressButton(button: operate)
            }
            let result = model.displayNumber
            XCTAssertEqual(result, testResult[index])
            model.allClear()
        }
        model.allClear()

    }

    func testDivideIrrationalNumber() {
        let testButtons = [["1","/","3","="],
                           ["1","/","3","*","3","="]]
        let testResult = ["0.333333333", "1"]
        for (index, buttons) in testButtons.enumerated() {
            var calc = ""
            for operate in buttons {
                calc += operate
                pressButton(button: operate)
            }
            let result = model.displayNumber
            XCTAssertEqual(result, testResult[index])
            model.allClear()
        }
        model.allClear()
    }

    func testOperation() {
        let testButtons = [["1","+","2","=","=","=","="],
                           ["-","3","+","2","=","=","=","="],
                           ["10","+","2","+","-","10","="],
                           ["1","+","2","*","3","="],
                           ["1","+","2","/","3","="],
                           ["1","+","2","*","3","c","4","="],
                           ["1","+","2","*","3","a","4","+","5","="],
        ]
        let testResult = ["9","5","2","9","1","12","9"]
        for (index, buttons) in testButtons.enumerated() {
            var calc = ""
            for operate in buttons {
                calc += operate
                pressButton(button: operate)
            }
            let result = model.displayNumber
            XCTAssertEqual(result, testResult[index])
            model.allClear()
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
            model.pushOperateButton(.addition)
        } else if button == "-" {
            model.pushOperateButton(.subtraction)
        } else if button == "*" {
            model.pushOperateButton(.multiplication)
        } else if button == "/" {
            model.pushOperateButton(.divide)
        } else if button == "=" {
            model.pushOperateButton(.equals)
        } else {
            model.pushNumberButton(button)
        }
    }

}
