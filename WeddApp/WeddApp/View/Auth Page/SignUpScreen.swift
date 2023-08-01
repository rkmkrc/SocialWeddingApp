//
//  SignUpScreen.swift
//  WeddApp
//
//  Created by Erkam Karaca on 1.08.2023.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var isSignedIn: Bool
    @Binding var isLoading: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    // Handle sign-up action here
                    if !isValidEmail(email) {
                        showAlert = true
                        alertMessage = "Please enter a valid email address."
                    } else if password.count < 6 {
                        showAlert = true
                        alertMessage = "Password should be at least 6 characters long."
                    } else if password != confirmPassword {
                        showAlert = true
                        alertMessage = "Passwords do not match."
                    } else {
                        isLoading = true
                        signUp(withEmail: email, password: password) { error in
                            isLoading = false
                            if error != nil {
                                showAlert = true
                                alertMessage = "Sign-up failed. \(error!.localizedDescription)"
                            } else {
                                // Sign-up successful, perform any necessary actions here
                                isSignedIn = true
                                print("SignedUp")
                            }
                        }
                    }
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                    
                }
                .padding(.horizontal)
            }
        }
    }
}
