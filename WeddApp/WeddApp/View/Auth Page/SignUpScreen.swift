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
    @Binding var regionCode: String
    @Binding var phoneNumber: String
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
                HStack {
                    TextField("", text: $regionCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 70)
                        .onAppear {
                            DispatchQueue.main.async {
                                let range = regionCode.index(regionCode.startIndex, offsetBy: 1)..<regionCode.endIndex
                                regionCode = "+" + regionCode[range]
                            }
                        }
                    Spacer()
                    TextField("555 555 55 55", text: $phoneNumber.max(10))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }.padding(.horizontal)
                Button("FillAuto"){
                    email = Constants.TestUser.email
                    password = Constants.TestUser.password
                    confirmPassword = Constants.TestUser.password
                    phoneNumber = Constants.TestUser.phoneNumber
                }
                Button(action: {
                    if !isValidEmail(email) {
                        showAlert = true
                        alertMessage = Constants.AlertMessages.enterValidEmail
                    } else if password.count < 6 {
                        showAlert = true
                        alertMessage = Constants.AlertMessages.passwordShouldBe
                    } else if password != confirmPassword {
                        showAlert = true
                        alertMessage = Constants.AlertMessages.passwordsNotMatched
                    } else {
                        isLoading = true
                        signUp(withEmail: email, password: password) { error in
                            isLoading = false
                            if error != nil {
                                showAlert = true
                                alertMessage = "Sign-up failed. \(error!.localizedDescription)"
                            } else {
                                // Sign-up successful
                                isSignedIn = true
                                createUser(email: email, userType: "Customer", phoneNumber: "\(regionCode)\(phoneNumber)")
                                SuccessOperations.onSuccess(message: SuccessOperations.SIGNED_UP)
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

