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
                    email = Constants.TestUser.email
                    password = Constants.TestUser.password
                }
                Button(action: {
                    if !isValidEmail(email) {
                        showAlert = true
                        alertMessage = Constants.AlertMessages.enterValidEmail
                    } else if password.count < 6 {
                        showAlert = true
                        alertMessage = Constants.AlertMessages.passwordShouldBe
                    } else {
                        isLoading = true
                        signIn(withEmail: email, password: password) { result, error in
                            isLoading = false
                            if error != nil {
                                showAlert = true
                                alertMessage = "Sign-in failed. \(error!.localizedDescription)"
                            } else {
                                isSignedIn = true
                                SuccessOperations.onSuccess(message: SuccessOperations.SIGNED_IN)
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
