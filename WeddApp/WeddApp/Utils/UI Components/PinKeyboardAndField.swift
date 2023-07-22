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
        return isSelected ? 1.1 : 1.0
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
        .padding()
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
    @State private var pin: String = ""
    @State private var correctPIN: String = "1234" // Replace "1234" with your correct PIN
    
    var body: some View {
        VStack {
            PINDisplay(pin: pin) // Display the PIN circles
            CallKeyboard(text: $pin)
            
            // Check the PIN and display result
            if pin.count == 4 {
                Text(checkPIN() ? "Correct PIN" : "Incorrect PIN")
                    .font(.headline)
                    .padding()
            } else {
                Text("Please Enter PIN")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white.opacity(0))
            }
        }
        .onChange(of: pin) { newValue in
            // Reset the PIN if typed count exceeds 4 digits
            if newValue.count == 4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    pin = ""
                }
            }
        }
    }
    
    // Function to check if the entered PIN is correct
    private func checkPIN() -> Bool {
        return pin == correctPIN
    }
}

struct PinKeyboardAndField_Previews: PreviewProvider {
    static var previews: some View {
        PinKeyboardAndField().background(AnimatedBackground())
    }
}