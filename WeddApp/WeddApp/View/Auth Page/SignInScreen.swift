//
//  SignInScreen.swift
//  WeddApp
//
//  Created by Erkam Karaca on 1.08.2023.
//

import Foundation
import SwiftUI

struct SignInView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var isSignedIn: Bool
    @Binding var isLoading: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button("FillAuto"){
                    email = "a@a.com"
                    password = "aaaaaa"
                }
                Button(action: {
                    // Handle sign-in action here
                    if !isValidEmail(email) {
                        showAlert = true
                        alertMessage = "Please enter a valid email address."
                    } else if password.count < 6 {
                        showAlert = true
                        alertMessage = "Password should be at least 6 characters long."
                    } else {
                        isLoading = true
                        signIn(withEmail: email, password: password) { result, error in
                            isLoading = false
                            if error != nil {
                                showAlert = true
                                alertMessage = "Sign-in failed. \(error!.localizedDescription)"
                            } else {
                                // Sign-in successful, perform any necessary actions here
                                print("SignedIn")
                                isSignedIn = true
                            }
                        }
                    }
                }) {
                    Text("Sign In")
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

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}
