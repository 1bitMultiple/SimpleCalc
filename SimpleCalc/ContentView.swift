//
//  ContentView.swift
//  SimpleCalc
//
//  Created by kamezawa.takayuki on 2022/01/10.
//

import SwiftUI

struct ContentView: View {
    private let margin = 4.0
    private let buttonHeight = 32.0
    private let buttons:[[TenKey]] = [[.init(.allClear), .init( .clear), .init(.inversionＳign),.init(.operation(.multiplication))],
                                      [.init(.numeral("7")),.init(.numeral("8")),.init(.numeral("9")),.init(.operation(.divide))],
                                      [.init(.numeral("4")),.init(.numeral("5")),.init(.numeral("6")),.init(.operation(.addition))],
                                      [.init(.numeral("1")),.init(.numeral("2")),.init(.numeral("3")),.init(.operation(.subtraction))],
                                      [.init(.numeral("0")),.init(.numeral("00")),.init(.decimalPoint),.init(.operation(.equals))]]


    var body: some View {
        GeometryReader { bodyView in
            VStack(){
                Text("0")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .background(.secondary)
                    .foregroundColor(.primary)
                    .padding(.all, margin)
                ForEach(buttons.indices) { index in
                    HStack {
                        ForEach( buttons[index], id: \.identifier) { button in
                            Button(action: {
                                // TODO:　ボタンによる動作を実装

                            }) {
                                Text(button.key.text).foregroundColor( button.key.color)
                                    .font(.title)
                                    .frame(width:  bodyView.size.width / 5, height: buttonHeight)
                                    .padding(.all, margin)
                                    .overlay(RoundedRectangle(cornerRadius: margin)
                                                .stroke(Color.gray, lineWidth: 2))
                                    .foregroundColor(.black)
                                    .background(button.key.bgColor)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
