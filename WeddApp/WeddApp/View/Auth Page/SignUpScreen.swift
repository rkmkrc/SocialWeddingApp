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
                        .frame(width: 70) // Optional: Set a fixed width for the region code part
                        .onAppear {
                            // Optional: If you want to select the region code when the view appears
                            DispatchQueue.main.async {
                                let range = regionCode.index(regionCode.startIndex, offsetBy: 1)..<regionCode.endIndex
                                regionCode = "+" + regionCode[range]
                            }
                        }
                    Spacer() // 1:3 ratio spacer
                    TextField("555 555 55 55", text: $phoneNumber.max(10))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                }.padding(.horizontal)
                Button("FillAuto"){
                    email = "a@a.com"
                    password = "aaaaaa"
                    confirmPassword = "aaaaaa"
                    phoneNumber = "1111111111"
                }
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
                                createUser(email: email, userType: "Customer", phoneNumber: "\(regionCode)\(phoneNumber)")
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

