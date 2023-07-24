//
//  Authentication.swift
//  WeddApp
//
//  Created by Erkam Karaca on 18.07.2023.
//

import Foundation
import Firebase

func signUp(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        if let error = error {
            completion(error)
        } else {
            completion(nil)
        }
    }
}

func signIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        if let error = error {
            completion(nil, error)
        } else {
            completion(authResult, nil)
        }
    }
}

func signOut(completion: @escaping (Error?) -> Void) {
    do {
        try Auth.auth().signOut()
        completion(nil)
    } catch let error {
        completion(error)
    }
}

func resetPassword(forEmail email: String, completion: @escaping (Error?) -> Void) {
    Auth.auth().sendPasswordReset(withEmail: email) { error in
        if let error = error {
            completion(error)
        } else {
            completion(nil)
        }
    }
}
