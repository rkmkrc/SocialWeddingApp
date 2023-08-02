//
//  AuthScreen.swift
//  WeddApp
//
//  Created by Erkam Karaca on 1.08.2023.
//

import Foundation
import SwiftUI

struct AuthenticationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var regionCode = "+90"
    @State private var phoneNumber = ""
    @State private var isSignIn = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSignedIn = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    if isSignIn {
                        SignInView(email: $email, password: $password, showAlert: $showAlert, alertMessage: $alertMessage, isSignedIn: $isSignedIn, isLoading: $isLoading)
                    } else {
                        SignUpView(email: $email, password: $password, confirmPassword: $confirmPassword, regionCode: $regionCode, phoneNumber: $phoneNumber, showAlert: $showAlert, alertMessage: $alertMessage, isSignedIn: $isSignedIn, isLoading: $isLoading)
                    }
                    Spacer()
                    if isSignIn {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        Text("Sign Up")
                            .foregroundColor(.blue)
                            .bold()
                            .onTapGesture {
                                isSignIn.toggle()
                            }
                    } else {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Text("Sign In")
                            .foregroundColor(.blue)
                            .bold()
                            .onTapGesture {
                                isSignIn.toggle()
                            }
                    }
                    NavigationLink(
                        destination: FormScreen(),
                        isActive: $isSignedIn,
                        label: { EmptyView() }
                    )
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                if isLoading {
                    // Show the spinner when isLoading is true
                    Color.black.opacity(0.3) // Semi-transparent gray background
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.5) // Adjust the spinner size if needed
                        )
                }
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
