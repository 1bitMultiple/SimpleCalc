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

    enum CalculatorMode {
        case input
        case calculate
    }

    enum OperatorType {
        case none
        case addition
        case subtraction
        case multiplication
        case divide
        case equals

        var text: String {
            switch self {
                case .none:
                    return ""
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
            // TODO =を押した時だけ現在の計算モードと置値で計算する
            // 計算モード中の演算は演算の変更のみ
            operation = operate
            return
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

            case .none:
                return
        }
        if case .none = operation {
            // 計算モードが何もないときには何もしない
            return
        } else if case .equals = operation {
            //　＝の時は計算モードを変更しないで計算のみ行う
        } else {
            operation = operate
        }
        displayNumber = computation.stringValue
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
        computation.multiplying(by: NSDecimalNumber.zero)
        displayNumber = editNumber.numeric
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

    var hasPoint: Bool {
        return value.contains(point)
    }
}
