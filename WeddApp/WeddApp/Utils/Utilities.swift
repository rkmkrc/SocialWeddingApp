//
//  Utilities.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//
import Foundation

extension Notification.Name {
    static let correctPINEntered = Notification.Name("correctPINEntered")
}

struct SuccessOperations {
    static let DOC_SET = "Wedding document successfully set!"
    static let USER_CREATED = "User created successfully!"
    
    static func onSuccess(message: String) {
        print(message)
    }
}

