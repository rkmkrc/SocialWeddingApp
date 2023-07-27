//
//  PinKeyboardAndField.swift
//  WeddApp
//
//  Created by Erkam Karaca on 22.07.2023.
//

import SwiftUI

struct CircleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.largeTitle)
            .foregroundColor(.black)
            .padding(5)
            .background(
                Circle()
                    .fill(Color.gray.opacity(0.5))
            )
    }
}

struct PINDisplay: View {
    let pin: String
    let numberOfCircles: Int = 4
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(0..<numberOfCircles), id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 75, height: 75)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(getDigit(at: index) == "" ? 0.3: 0.9), lineWidth: 1) // Border
                    )
                    .overlay(
                        Text(getDigit(at: index))
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    )
                    .scaleEffect(getScale(at: index))
                    .onChange(of: pin) { _ in
                        withAnimation(.easeIn) {}
                    }
            }
        }
    }
    
    private func getDigit(at index: Int) -> String {
        guard index < pin.count else {
            return ""
        }
        let digitIndex = pin.index(pin.startIndex, offsetBy: index)
        return String(pin[digitIndex])
    }
    private func getScale(at index: Int) -> CGFloat {
        let isSelected = index < pin.count
        return isSelected ? 1.07 : 1.0
    }
}



struct CallKeyboard: View {
    @Binding var text: String
    
    let rows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["\u{2665}", "0", "\u{232B}"]
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        CallKeyboardButton(text: $text, key: key)
                    }
                }
            }
        }
    }
}

struct CallKeyboardButton: View {
    @Binding var text: String
    let key: String
    
    var body: some View {
        Button(action: {
            if key == "\u{232B}" {
                text = String(text.dropLast())
            } else {
                text += key
            }
        }) {
            Text(key)
                .font(.title)
                .frame(width: 75, height: 75)
                .foregroundColor(.black)
                .background(Color.white.opacity(0.5))
                .cornerRadius(40)
        }
    }
}

struct PinKeyboardAndField: View {
    @ObservedObject var model = ViewModel(id: "1111")
    @State private var pin: String = ""
    @State private var correctPIN: String = "1111"
    @State private var isCorrectPIN: Bool = false
    @State private var pinWarning: String = ""
    let pinList = ["1111", "1112", "1113", "1114"]
    var body: some View {
        VStack {
            PINDisplay(pin: pin) // Display the PIN circles
            CallKeyboard(text: $pin)
            Text(pinWarning)
        }
        .onChange(of: pin) { newValue in
            if newValue.count == 4 {
                model.isWeddingExist(id: pin) { exists in
                    if exists {
                        self.isCorrectPIN = true
                        let pinInfo: [String: String] = ["pin": pin]
                        NotificationCenter.default.post(name: .correctPINEntered, object: nil, userInfo: pinInfo)
                    } else {
                        pinWarning = "Incorrect PIN"
                        DispatchQueue.main.asyncAfter (deadline: .now() + 0.5) {
                            self.pin = ""
                            self.pinWarning = ""
                        }
                    }
                }
            }
        }
    }
}
/*
struct PinKeyboardAndField_Previews: PreviewProvider {
    static var previews: some View {
        PinKeyboardAndField().background(AnimatedBackground())
    }
}
*/


