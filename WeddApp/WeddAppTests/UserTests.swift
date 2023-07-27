//
//  UserTests.swift
//  ReservationAppTests
//
//  Created by Erkam Karaca on 3.06.2023.
//

import XCTest
import Firebase
import FirebaseFirestore
@testable import WeddApp

class UserTests: XCTestCase {
    var ref: DatabaseReference!
    
    override func setUp() {
        super.setUp()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        ref = Database.database().reference()
    }
    
    override func tearDown() {
        super.tearDown()
        if let ref = ref {
            ref.child("Users").removeValue()
        }
    }
    
    func testCreateUser() {
        let expectation = self.expectation(description: "Create user")
        let userName = "John Doe"
        let email = "john.doe@example.com"
        let userType = "Customer"
        let phoneNumber = "123456"
        
        // Create a mock user for testing
        let user = User(userName: userName, email: email, userType: userType, phoneNumber: phoneNumber)
        
        // Use Firebase Auth to create a user with email and password
        Auth.auth().createUser(withEmail: user.email, password: "password") { (authResult, error) in
            XCTAssertNil(error, "Error creating user: \(error?.localizedDescription ?? "")")
            
            // Check if user creation was successful
            if let _ = authResult?.user {
                // Use Firebase Firestore to save the user data
                let db = Firestore.firestore()
                db.collection("Users").addDocument(data: user.toDictionary()) { error in
                    XCTAssertNil(error, "Error saving user data: \(error?.localizedDescription ?? "")")
                    expectation.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}



