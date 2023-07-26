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
    @State private var pin: String = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Text("Passcode")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    Text("Please type the number on the red card.")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                    PinKeyboardAndField().padding().ignoresSafeArea()
                    NavigationLink(destination: HomePage(pin: self.pin), isActive: $isOTPSuccessful) { EmptyView() }
                    
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height) 
                .background(AnimatedBackground(colorSet: 0).ignoresSafeArea())
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: .correctPINEntered)) { notification in
            if let pinInfo = notification.userInfo as? [String: String], let pinValue = pinInfo["pin"] {
                self.isOTPSuccessful = true
                self.pin = pinValue
            }
        }
        }
}

struct OTPPage_Previews: PreviewProvider {
    static var previews: some View {
        OTPPage()
    }
}

