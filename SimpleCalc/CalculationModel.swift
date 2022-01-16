//
//  CalculationModel.swift
//  SimpleCalc
//
//  Created by kamezawa.takayuki on 2022/01/11.
//

import Foundation

class CalclationModel: ObservableObject {
    @Published var displayNumber: String = "0"
    var operation: OperatorType = .addition
    var editNumber: NumberToEdit = .init()
    var computation = NSDecimalNumber.zero
    var mode = CalculatorMode.input
    let roundedScale = 9

    enum CalculatorMode {
        case input
        case calculate
    }

    enum OperatorType {
        case addition
        case subtraction
        case multiplication
        case divide
        case equals

        var text: String {
            switch self {
                case .addition:
                    return "+"
                case .subtraction:
                    return "-"
                case .multiplication:
                    return "×"
                case .divide:
                    return "÷"
                case .equals:
                    return "="
            }
        }
    }

    func pushNumberButton(_ number: String) {
        if case .calculate = mode {
            editNumber.clear()
            mode = .input
        }
        editNumber.appendNumber(number)
        displayNumber = editNumber.numeric
    }

    func pushOperateButton(_ operate: OperatorType) {
        if case .calculate = mode {
            // 計算モード中の演算は演算の変更のみ
            switch operate {
                case .addition, .subtraction, .multiplication, .divide:
                    operation = operate
                    return

                case .equals:
                    break
            }
        }
        mode = .calculate
        let number = editNumber.decimal
        print("debug: \(computation) \(operation.text) \(number)")
        switch operation {
            case .addition:
                computation =  computation.adding(number)

            case .subtraction:
                computation = computation.subtracting(number)

            case .multiplication:
                computation = computation.multiplying(by: number)

            case .divide:
                // 0の時は例外エラー
                if number.compare(NSDecimalNumber.zero) == .orderedSame {
                    displayNumber = "error"
                    return
                }
                computation = computation.dividing(by: number)

            case .equals:
                break
        }
        if case .equals = operation {
            //　＝の時は計算モードを変更しないで計算のみ行う

        } else {
            operation = operate
        }
        displayNumber = createRoundedNumber(decimalNumber: computation)
    }

    func toggleNegative() {
        editNumber.isNegative.toggle()
        displayNumber = editNumber.numeric
    }

    func addPoint() {
        editNumber.appendPoint()
        displayNumber = editNumber.numeric
    }

    func clear() {
        editNumber.clear()
        displayNumber = editNumber.numeric
    }

    func allClear() {
        clear()
        computation = NSDecimalNumber.zero
        operation = .addition
        displayNumber = editNumber.numeric
    }

    private func createRoundedNumber(decimalNumber: NSDecimalNumber) -> String {
        return decimalNumber.rounding(accordingToBehavior: self).stringValue
    }
}

extension CalclationModel: NSDecimalNumberBehaviors {
    func roundingMode() -> NSDecimalNumber.RoundingMode {
        return .plain
    }

    func scale() -> Int16 {
        return Int16(roundedScale)
    }

    func exceptionDuringOperation(_ operation: Selector,
                                  error: NSDecimalNumber.CalculationError,
                                  leftOperand: NSDecimalNumber,
                                  rightOperand: NSDecimalNumber?) -> NSDecimalNumber? {
        return NSDecimalNumber.zero
    }
}

class NumberToEdit {
    let zero = "0"
    let point = "."

    var isNegative = false
    private var value: String = ""

    var numeric: String {
        set(newNumber) {
            let number = newNumber.trimmingCharacters(in: .whitespacesAndNewlines)
            if number.isEmpty {
                value = ""
                return
            }
            let decimal = NSDecimalNumber(string: number)
            value = abs(number: decimal).stringValue
        }
        get {
            return (isNegative ? "-" : "") + (value.isEmpty ? zero : value)
        }
    }

    var decimal: NSDecimalNumber {
        return NSDecimalNumber(string: numeric)
    }

    func clear() {
        value = ""
        isNegative = false
    }

    func appendNumber(_ number: String) {
        value = value + number
        if hasPoint { return }
        let normalizedNumber = NSDecimalNumber(string: value).stringValue
        if value != normalizedNumber {
            value = normalizedNumber
        }
    }

    @discardableResult
    func appendPoint() -> Bool {
        if value.isEmpty {
            value = zero + String(point)
            return true
        }
        if hasPoint { return false }
        value += String(point)
        return true
    }

    private func abs(number: NSDecimalNumber) -> NSDecimalNumber {
        if number.compare(NSDecimalNumber.zero) == .orderedAscending {
            return NSDecimalNumber.zero.subtracting(number)
        }
        return number
    }

    private var hasPoint: Bool {
        return value.contains(point)
    }
}
