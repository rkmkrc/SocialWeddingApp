//
//  Network Errors.swift
//  WeddApp
//
//  Created by Erkam Karaca on 25.07.2023.
//

import Foundation

// Define a custom error enum
enum WeddingError: Error {
    case invalidData
    case networkError(String)
    case firestoreError(String)
    case documentError(String)
    // Add more cases as needed
}

// Create a function that may throw custom errors
func processWeddingData(_ data: [String: Any]) throws {
    guard let id = data["id"] as? String,
          let groomName = data["groomName"] as? String,
          let brideName = data["brideName"] as? String else {
        throw WeddingError.invalidData
    }

    // Simulate a network error
    if id == "networkError" {
        throw WeddingError.networkError("Network request failed.")
    }

    // Simulate a Firestore error
    if id == "firestoreError" {
        throw WeddingError.firestoreError("Firestore query failed.")
    }
}

// Example usage
func processWeddingDataExample() {
    let data: [String: Any] = [
        "id": "wedding123",
        "groomName": "John",
        "brideName": "Jane"
    ]

    do {
        try processWeddingData(data)
        print("Wedding data processed successfully.")
    } catch WeddingError.invalidData {
        print("Invalid data format.")
    } catch let WeddingError.networkError(errorMessage) {
        print("Network Error: \(errorMessage)")
    } catch let WeddingError.firestoreError(errorMessage) {
        print("Firestore Error: \(errorMessage)")
    } catch {
        print("An unknown error occurred.")
    }
}
