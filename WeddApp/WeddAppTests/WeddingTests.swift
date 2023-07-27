//
//  WeddingTests.swift
//  WeddAppTests
//
//  Created by Erkam Karaca on 25.07.2023.
//

import Foundation
import XCTest
import Firebase
import FirebaseFirestore
@testable import WeddApp

class WeddingTests: XCTestCase {
    var ref: DatabaseReference!
    var weddingID: String! = "1"
    
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
            ref.child("Weddings").removeValue()
        }
    }
    
    func testCreateWedding() {
        let expectation = self.expectation(description: "Create wedding")
        // Create a mock wedding for testing
        let wedding = TestModels.wedding
        
        // Use Firebase Firestore to save the user data
        let db = Firestore.firestore()
        db.collection("Weddings").addDocument(data: wedding.toDictionary()) { error in
            XCTAssertNil(error, "Error saving wedding data: \(error?.localizedDescription ?? "")")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFindWeddingByID() {
        // Ensure a valid wedding ID is available from the previous test
        XCTAssertNotNil(weddingID, "Wedding ID is nil")
        
        let expectation = self.expectation(description: "Find wedding by ID")
        
        // Use Firebase Firestore to fetch the wedding document by its id field
        let db = Firestore.firestore()
        let collectionRef = db.collection("Weddings")
        let query = collectionRef.whereField("id", isEqualTo: Int(weddingID) as Any)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                XCTFail("Error fetching wedding document: \(error.localizedDescription)")
            } else {
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    XCTFail("Failed to find the wedding document")
                    return
                }
                
                // Ensure there's only one document with the provided id field
                XCTAssertEqual(documents.count, 1)
                
                let weddingDocument = documents[0]
                let weddingData = weddingDocument.data()
                
                XCTAssertNotNil(weddingData, "Wedding data is nil")
                print(weddingData)
                
                // Add more assertions for other properties if needed
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}




