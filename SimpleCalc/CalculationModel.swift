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

    func appendNumber(_ number: String) {
        // TODO: 入力モードが計算モードなら数値入力モードに変更して置値をクリアしておく

        editNumber.appendNumber(number)
        displayNumber = editNumber.numeric
    }

    func calcurate(_ operate: OperatorType) {
        // TODO: 入力モードが計算モードなら演算タイプを変えるだけにする

        let number = editNumber.decimal
        switch operation {
            case .addition:
                computation.adding(number)

            case .subtraction:
                computation.subtracting(number)

            case .multiplication:
                computation.multiplying(by: number)

            case .divide:
                // 0の時は例外エラー
                computation.dividing(by: number)

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
