//
//  TenKeyModel.swift
//  SimpleCalc
//
//  Created by kamezawa.takayuki on 2022/01/10.
//

import Foundation
import SwiftUI

struct TenKey {
    let identifier = UUID()
    let key: TenKeyType

    init(_ tenKeyType: TenKeyType) {
        self.key = tenKeyType
    }

    enum CalculationOperatorType {
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

    enum TenKeyType {
        case numeral(String)
        case decimalPoint
        case inversionＳign
        case operation(CalculationOperatorType)
        case clear
        case allClear

        var text: String {
            switch self {
                case .numeral(let number):
                    return number
                case .decimalPoint:
                    return "."
                case .inversionＳign:
                    return "+/-"
                case .operation(let operation):
                    return operation.text
                case .clear:
                    return "C"
                case .allClear:
                    return "CA"

            }
        }

        var color: Color {
            switch self {
                case .numeral(_), .decimalPoint, .inversionＳign:
                    return Color.primary
                case .operation(_):
                    return Color.red
                case .clear, .allClear:
                    return Color.white
            }
        }

        var bgColor: Color {
            switch self {
                case .numeral(_), .decimalPoint, .inversionＳign:
                    return Color.gray
                case .operation(_):
                    return Color.blue
                case .clear, .allClear:
                    return Color.red
            }
        }
    }
}


