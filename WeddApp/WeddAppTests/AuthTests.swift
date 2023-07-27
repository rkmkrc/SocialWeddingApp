//
//  AuthTests.swift
//  ReservationAppTests
//
//  Created by Erkam Karaca on 3.06.2023.
//

import XCTest
@testable import WeddApp
import Firebase

class AuthenticationTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        // Configure Firebase app for testing only if it hasn't been configured yet
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    override func tearDown() {
        super.tearDown()
        // Clean up any test data or state if needed
    }
    
    func testSignUpWithEmail() {
        let email = "test@example.com"
        let password = "test1234"
        let expectation = self.expectation(description: "Sign up with email")
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            XCTAssertNil(error, "Sign up with email failed: \(error?.localizedDescription ?? "")")
            XCTAssertNotNil(authResult, "Sign up with email succeeded but authResult is nil")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignInWithEmail() {
        let email = "test@example.com"
        let password = "test1234"
        let expectation = self.expectation(description: "Sign in with email")
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            XCTAssertNil(error, "Sign in with email failed: \(error?.localizedDescription ?? "")")
            XCTAssertNotNil(authResult, "Sign in with email succeeded but authResult is nil")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignOut() {
        let expectation = self.expectation(description: "Sign out")
        
        Auth.auth().signInAnonymously { _, _ in
            do {
                try Auth.auth().signOut()
                
                if Auth.auth().currentUser == nil {
                    expectation.fulfill()
                } else {
                    XCTFail("Sign out failed")
                }
            } catch let error {
                XCTFail("Sign out threw an error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testResetPassword() {
        let email = "test@example.com"
        let expectation = self.expectation(description: "Reset password")
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            XCTAssertNil(error, "Reset password failed: \(error?.localizedDescription ?? "")")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
