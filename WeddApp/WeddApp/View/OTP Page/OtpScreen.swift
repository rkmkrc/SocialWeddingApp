//
//  OtpScreen.swift
//  WeddApp
//
//  Created by Erkam Karaca on 21.07.2023.
//

import Foundation
import SwiftUI

struct OTPPage: View {
    @State private var otp: String = ""
    @State private var isOTPSuccessful: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Passcode")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Text("Please type the number on the red card.")
                    .font(.title3)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                PinKeyboardAndField().padding().ignoresSafeArea()
                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height) // Set the frame to the full screen size
            .background(AnimatedBackground(colorSet: 0).ignoresSafeArea())
        }
    }
}

struct OTPPage_Previews: PreviewProvider {
    static var previews: some View {
        OTPPage()
            .previewDevice("iPhone 12")
    }
}
