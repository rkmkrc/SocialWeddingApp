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
    let email: String
    let userType: String
    let phoneNumber: String
    let weddingID: String
}

func createUser(email: String, userType: String, phoneNumber: String) {
    if let user = Auth.auth().currentUser {
        let userID = user.uid
        
        let db = Firestore.firestore()
        let userCollection = db.collection("Users")
        let newUserDocument = userCollection.document(userID)
        
        var weddingID = ""
        generateUniqueID { uniqueID, error in
            if let error = error {
                // Handle the error
                print("Error generating unique ID: \(error.localizedDescription)")
            } else if let uniqueID = uniqueID {
                // Use the generated unique ID
                print("Unique Wedding id : \(uniqueID)")
                weddingID = uniqueID
                
                let user = User(email: email, userType: userType, phoneNumber: phoneNumber, weddingID: weddingID)
                
                newUserDocument.setData(user.toDictionary()) { error in
                    if let error = error {
                        // handle pop up
                        processWeddingError(error: WeddingError.firestoreError(error.localizedDescription))
                    } else {
                        SuccessOperations.onSuccess(message: SuccessOperations.USER_CREATED)
                    }
                }
            }
        }
    }
}

extension User {
    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "userType": userType,
            "phoneNumber": phoneNumber,
            "weddingID": weddingID
        ]
    }
}
