//
//  User.swift
//  WeddApp
//
//  Created by Erkam Karaca on 18.07.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User {
    let userName: String
    let email: String
    let userType: String
    let phoneNumber: String
}

func createUser(userName: String, email: String, userType: String, phoneNumber: String) {
    let db = Firestore.firestore()
    let userCollection = db.collection("Users")
    let newUserDocument = userCollection.document()
    let user = User(userName: userName, email: email, userType: userType, phoneNumber: phoneNumber)

    newUserDocument.setData(user.toDictionary()) { error in
        if let error = error {
            processWeddingError(error: WeddingError.firestoreError(error.localizedDescription))
        } else {
            SuccessOperations.onSuccess(message: SuccessOperations.USER_CREATED)
        }
    }
}

extension User {
    func toDictionary() -> [String: Any] {
        return [
            "userName": userName,
            "email": email,
            "userType": userType,
            "phoneNumber": phoneNumber
        ]
    }
}
