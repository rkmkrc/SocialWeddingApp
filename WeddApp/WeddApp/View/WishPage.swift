//
//  WishPage.swift
//  WeddApp
//
//  Created by Erkam Karaca on 17.08.2023.
//

import Foundation
import SwiftUI

struct WishPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model: ViewModel
    @Binding var addWishButtonTapped: Bool
    @State private var showingAlert = false
    @State private var guestName = ""
    @State private var wish = ""
    private let maxWishLength = 150
    private let currentDate = Date()
    var isSubmitButtonDisabled: Bool {
        guestName.isEmpty || wish.isEmpty
    }
    var body: some View {
        NavigationStack {
            Form {
                Section("Make a wish") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Name")
                            .font(.headline)
                        TextField("", text: $guestName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                        Text("Your Wish")
                            .font(.headline)
                        TextEditor(text: $wish)
                            .frame(height: 130)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                            .overlay(
                                Text("\(wish.count)/\(maxWishLength)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.all, 8),
                                alignment: .bottomTrailing
                            )
                            .onChange(of: wish, perform: { newValue in
                                if wish.count > maxWishLength {
                                    wish = String(wish.prefix(maxWishLength))
                                }
                            })
                        
                        Text(dateFormatter.string(from: currentDate))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                    }
                }
            }
            Button(action: {
                tapOnSubmit()
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(isSubmitButtonDisabled ? Color.secondary : Color.blue)
                    .cornerRadius(10)
            }.disabled(isSubmitButtonDisabled)
                .padding()
                .navigationTitle("\u{1F33A} Make a wish \u{1F33A}")
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text("Your wish has been successfully sent."),
                        dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss() // Dismiss the view after the alert is dismissed
                        }
                    )
                }
        }.onAppear() {
            addWishButtonTapped = false
        }
    }
    
    func tapOnSubmit() {
        if let guestID = UserDefaults.standard.string(forKey: "guestID-\(model.id)") {
            // The guestID is not nil, you can use it
            print("You have already sent a wish.")
            print("Guest ID: \(guestID)")
        } else {
            // The guestID is nil
            print("Guest ID is not set")
            let wish = Wish(guestName: self.guestName, wish: self.wish, date: self.currentDate)
            model.uploadWish(wish: wish)
            showingAlert = true
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
/*
 struct WishFormView_Previews: PreviewProvider {
 static var previews: some View {
 WishFormView()
 }
 }
 
 
 */
